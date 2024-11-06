import { Category } from '@/entities/category.entity';
import { Video } from '@/entities/video.entity';
import { WatchingVideoHistory } from '@/entities/watching-video-history.entity';
import { BadRequestException, Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Not, Repository } from 'typeorm';
import { User } from '@/entities/user.entity';
import { ChannelItem, VideoItemDto } from './dto/video-item.dto';
import { Cron, CronExpression } from '@nestjs/schedule';
import { VideoTrendService } from '../video-trend/video-trend.service';
import { ApiConfigService } from '@/shared/services/api-config.service';
import { Channel } from '@/entities/channel.entity';
import { VideoTrend } from '@/entities/video-trend.entity';
import { PaginationDto } from '../video/dto/request/pagination.dto';
import { objectResponse } from '../../shared/utils/response-metadata.function';
import { PaginationMetadata } from '../video/dto/response/pagination.meta';
import { VideoService } from '../video/video.service';
import { VimeoService } from '@/shared/services/vimeo.service';
import { ThumbnailService } from '../thumbnail/thumbnail.service';
import { ChannelService } from '../channel/channel.service';
import { CategoryService } from '../category/category.service';

@Injectable()
export class HomeService {
  constructor(
    @InjectRepository(Video) private videoRepository: Repository<Video>,
    @InjectRepository(Category) private cateRepository: Repository<Category>,
    @InjectRepository(WatchingVideoHistory) private watchingRepository: Repository<WatchingVideoHistory>,
    @InjectRepository(User) private userRepository: Repository<User>,
    @InjectRepository(Channel) private channelRepository: Repository<Channel>,
    @InjectRepository(VideoTrend) private readonly videoTrendRepository: Repository<VideoTrend>,
    private readonly videoService: VideoService,
    private vimeoService: VimeoService,
    private apiConfig: ApiConfigService,
    private videoTrendService: VideoTrendService,
    private thumbnailService: ThumbnailService,
    private channelService: ChannelService,
    private categoryService: CategoryService,
    @Inject('TIME_CRON_JOB') private readonly timeCronJob: number,
  ) {
    // this.timeCronJob = this.apiConfig.getString('TIME_CRON_JOB');
  }

  @Cron(CronExpression.EVERY_DAY_AT_MIDNIGHT)
  async createListVideoHotTrend() {
    // clear video hot trend
    await this.videoTrendService.deleteAll();

    //The video was posted 14 days ago
    const numberDayValid = this.apiConfig.getNumber('NUMBER_DAY_VALID');
    const viewDailyValid = this.apiConfig.getNumber('VIEW_DAILY_VALID');
    const viewTotalValid = this.apiConfig.getNumber('VIEW_TOTAL_VALID');

    const ratingValid = this.apiConfig.getNumber('RATING_VALID');

    const postedDateValid = new Date();
    postedDateValid.setDate(postedDateValid.getDate() - numberDayValid);

    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const formattedYesterday = yesterday.toISOString().split('T')[0];

    const result = await this.videoRepository
      .createQueryBuilder('video')
      .leftJoinAndSelect('video.views', 'views')
      .innerJoinAndSelect('video.channel', 'channel')
      .innerJoinAndSelect('video.category', 'category')
      .where('video.createdAt <= :postedDateValid', { postedDateValid: postedDateValid })
      .andWhere('video.isPublish = true')
      .andWhere('views.viewDate = :yesterday', { yesterday: formattedYesterday })
      .andWhere('views.totalView >= :totalView', { totalView: viewDailyValid })
      .andWhere('video.ratings >= :rating', { rating: ratingValid })
      .andWhere('video.numberOfViews >= :total', { total: viewTotalValid })
      .orderBy('views.totalView', 'DESC', 'NULLS LAST')
      .limit(10)
      .select([
        'video.id',
        'video.title',
        'video.workoutLevel',
        'video.duration',
        'video.ratings',
        'video.createdAt',
        'video.numberOfViews',
        'channel.numberOfFollowers',
        'channel.isBlueBadge',
        'channel.isPinkBadge',
        'channel.image',
        'channel.name',
        'channel.id',
        'category.id',
        'category.title',
      ])
      .getMany();

    const banners = [];
    result.forEach(async (obj) => {
      banners.push(obj);
      await this.videoTrendService.createVideoTrend(obj);
    });
    return result;
  }

  async getListVideoTrend() {
    const result = await this.videoTrendService.getAll();
    if (!result) {
      throw new BadRequestException();
    }
    const response = await Promise.all(
      result.map(async (video) => {
        const [thumbnail, channel, category] = await Promise.all([
          this.thumbnailService.getSelectedThumbnail(video.videoId),
          this.channelService.findOne(video.channelId),
          this.categoryService.getCategoryById(video.categoryId),
        ]);

        const { categoryId, channelId, videoLength, ...restOfVideo } = video;
        const durationsVideo = videoLength;
        return {
          ...restOfVideo,
          durationsVideo,
          channel: {
            id: channel.id,
            name: channel.name,
            image: channel.image,
            isBlueBadge: channel.isBlueBadge,
            isPinkBadge: channel.isPinkBadge,
            numberOfFollowers: channel.numberOfFollowers,
          },
          category: {
            id: category.id,
            title: category.title,
          },
          thumbnailURL: thumbnail && thumbnail.image ? thumbnail.image : null,
        };
      }),
    );
    return response;
  }

  convertToVideoItemDto(rawData: any): VideoItemDto {
    const videoItem = new VideoItemDto();
    videoItem.id = rawData.video_id;
    videoItem.thumbnailURL = rawData.thumbnails_image;
    videoItem.numberOfViews = rawData.number_of_views || null;
    videoItem.videoLength = rawData.video_duration || null;
    videoItem.title = rawData.video_title;
    videoItem.ratings = rawData.video_ratings;
    videoItem.createdAt = new Date(rawData.video_createdAt);
    videoItem.workoutLevel = rawData.video_workoutLevel;
    videoItem.duration = rawData.video_duration;

    videoItem.channel = new ChannelItem();
    videoItem.channel.name = rawData.channel_name;
    videoItem.channel.image = rawData.channel_avt;
    videoItem.channel.isBlueBadge = rawData.is_blue_badge;
    videoItem.channel.isPinkBadge = rawData.is_pink_badge;

    videoItem.category = rawData.category_name;

    return videoItem;
  }
  // Get list categories order by total view
  async getCategories(limit?: number) {
    const result = await this.cateRepository
      .createQueryBuilder('categories')
      .select(['categories.id', 'categories.numberOfViews', 'categories.image', 'categories.title'])
      .limit(limit)
      .orderBy('categories.numberOfViews', 'DESC')
      .getMany();
    return result;
  }

  async specificCategory(userId: number, categoryId: number, dto: PaginationDto) {
    dto.page = +dto.page;
    const selected = [
      'v.id',
      'v.title',
      'v.numberOfViews',
      'v.url',
      'v.ratings',
      'v.workoutLevel',
      'v.durationsVideo',
      'v.duration',
      'v.createdAt',
      'c.title',
      'c.id',
      'ch.id',
      'ch.name',
      'ch.image',
      'ch.isBlueBadge',
      'ch.isPinkBadge',
      'ch.numberOfFollowers',
    ];
    const [list, total] = await this.videoRepository.findAndCount({
      where: {
        category: {
          id: categoryId,
        },
        isPublish: true,
      },
    });
    const totalPage = Math.ceil(total / dto.take);

    //get video user watch history
    const rcmVideos = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoinAndSelect('v.category', 'c')
      .leftJoinAndSelect('v.watchingVideoHistories', 'wvh')
      .leftJoin('v.channel', 'ch')
      .leftJoin('follows', 'f', 'f.channelId = ch.id AND f.userId = :userId', { userId })
      .where('c.id = :categoryId', { categoryId })
      .andWhere('v.isPublish = true')
      .andWhere('(wvh.userId = :userId OR f.userId = :userId)', { userId })
      .select(selected)
      .orderBy('wvh.updatedAt', 'DESC')
      .addOrderBy('v.createdAt', 'DESC')
      .orderBy('v.numberOfViews', 'DESC')
      .getMany();

    const rcmVideoIds = rcmVideos.map((video) => video.id);
    let videosForPage1: any[] = [];
    if (rcmVideoIds.length > 0) {
      const otherVideosQuery = await (
        await this.queryVideoNotIn(rcmVideoIds, categoryId, selected)
      ).getMany();

      if (rcmVideos.length < dto.take) {
        const extraNeeded = dto.take - rcmVideos.length;
        const extraVideos = otherVideosQuery.slice(0, extraNeeded);
        videosForPage1 = [...rcmVideos, ...extraVideos];
      } else {
        videosForPage1 = rcmVideos;
      }
    } else {
      let topViewVideo = await this.videoRepository.find({
        take: 12,
        where: {
          category: {
            id: categoryId,
          },
        },
        order: {
          numberOfViews: 'DESC',
        },
        relations: {
          channel: true,
          category: true,
        },
      });
      videosForPage1 = topViewVideo;
    }

    const videosForPage1ID = videosForPage1.map((video) => video.id);
    if (dto.page === 1) {
      const update = await Promise.all(
        videosForPage1.map(async (video) => {
          const thumbnail = await this.thumbnailService.getSelectedThumbnail(video.id);

          return {
            ...video,
            thumbnailURL: thumbnail && thumbnail.image ? thumbnail.image : null,
          };
        }),
      );
      return objectResponse(update, new PaginationMetadata(total, dto.page, dto.take, totalPage));
    } else {
      let remainVideos = await (
        await this.queryVideoNotIn(videosForPage1ID, categoryId, selected)
      )
        .limit(dto.take)
        .offset(dto.take * (dto.page - 2))
        .getMany();

      const updatedRemainVideos = await Promise.all(
        remainVideos.map(async (video) => {
          const [thumbnail] = await Promise.all([this.thumbnailService.getSelectedThumbnail(video.id)]);

          return {
            ...video,
            thumbnailURL: thumbnail.image,
          };
        }),
      );
      return objectResponse(
        updatedRemainVideos,
        new PaginationMetadata(total, dto.page, dto.take, totalPage),
      );
    }
  }

  async queryVideoNotIn(array: number[], categoryId: number, selected: string[]) {
    return this.videoRepository
      .createQueryBuilder('v')
      .leftJoinAndSelect('v.category', 'c')
      .leftJoin('v.channel', 'ch')
      .where('c.id = :categoryId', { categoryId })
      .andWhere('v.isPublish = true')
      .andWhere('v.id NOT IN (:...array)', { array })
      .select(selected)
      .orderBy('v.createdAt', 'DESC')
      .addOrderBy('v.numberOfViews', 'DESC');
  }

  async specificCategoryWithOutLogin(categoryId: number, dto: PaginationDto) {
    const selected = [
      'v.id',
      'v.title',
      'v.numberOfViews',
      'v.url',
      'v.ratings',
      'v.workoutLevel',
      'v.duration',
      'v.durationsVideo',
      'v.createdAt',
      'c.id',
      'c.title',
      'ch.id',
      'ch.name',
      'ch.image',
      'ch.isBlueBadge',
      'ch.numberOfFollowers',
      'ch.isPinkBadge',
    ];
    const [list, total] = await this.videoRepository.findAndCount({
      where: {
        category: {
          id: categoryId,
        },
        isPublish: true,
      },
    });
    const totalPage = Math.ceil(total / dto.take);
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoinAndSelect('v.category', 'c')
      .leftJoin('v.channel', 'ch')
      .where('c.id = :categoryId', { categoryId })
      .select(selected)
      .orderBy('v.createdAt', 'DESC')
      .addOrderBy('v.numberOfViews', 'DESC')
      .limit(dto.take)
      .offset(dto.take * (dto.page - 1))
      .getMany();

    const updateResult = await Promise.all(
      result.map(async (video) => {
        const [thumbnail] = await Promise.all([this.thumbnailService.getSelectedThumbnail(video.id)]);

        return {
          ...video,
          thumbnailURL: thumbnail.image,
        };
      }),
    );

    return objectResponse(updateResult, new PaginationMetadata(total, dto.page, dto.take, totalPage));
  }

  async topView7Day() {
    const selected = [
      'v.id',
      'v.title',
      'v.numberOfViews',
      'v.url',
      'v.ratings',
      'v.workoutLevel',
      'v.duration',
      'v.durationsVideo',
      'v.createdAt',
      'c.id',
      'c.title',
      'ch.id',
      'ch.name',
      'ch.numberOfFollowers',
      'ch.image',
      'ch.isBlueBadge',
      'ch.isPinkBadge',
      'SUM(vw."totalView") AS "weeklyTotalView"', // Tính tổng view cho tuần
    ];
    const dateValid = new Date();
    dateValid.setDate(dateValid.getDate() - 7);

    const topVideos = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoinAndSelect('v.category', 'c')
      .leftJoin('v.channel', 'ch')
      .innerJoin('views', 'vw', 'vw."videoId" = v.id')
      .where('vw."viewDate" >= :dateValid', { dateValid })
      .andWhere('v.isPublish = true')
      .select(selected)
      .groupBy('v.id')
      .addGroupBy('c.id')
      .addGroupBy('c.title')
      .addGroupBy('ch.id')
      .addGroupBy('ch.name')
      .addGroupBy('ch.isBlueBadge')
      .addGroupBy('ch.isPinkBadge')
      .orderBy('"weeklyTotalView"', 'DESC')
      .limit(32)
      .getMany();

    return topVideos;
  }

  async recentWatchedVideo(userId: number) {
    const selected = ['v.id'];
    const recentWatchedVideos = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoinAndSelect('v.category', 'c')
      .leftJoin('v.channel', 'ch')
      .innerJoin('v.watchingVideoHistories', 'wvh', 'wvh.userId = :userId', { userId })
      .select(selected)
      .andWhere('v.isPublish = true')
      .orderBy('wvh.updatedAt', 'DESC')
      .limit(4)
      .getMany(); // Fetch the result

    return recentWatchedVideos;
  }

  async followedVideo(userId: number) {
    const dateLimit = new Date();
    dateLimit.setDate(dateLimit.getDate() - 14);
    const selected = ['v.id'];
    const followedVideos = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoinAndSelect('v.category', 'c')
      .leftJoin('v.channel', 'ch')
      .innerJoin('follows', 'f', 'f.channelId = ch.id AND f.userId = :userId', { userId })
      .where('v.createdAt >= :dateLimit', { dateLimit })
      .andWhere('v.isPublish = true')
      .orderBy('v.numberOfViews', 'DESC')
      .select(selected)
      .limit(32)
      .getMany();

    return followedVideos;
  }

  async youMayLike(userId: number) {
    const foundChannel = await this.channelRepository.findOne({
      where: {
        user: {
          id: userId,
        },
      },
    });
    const selected = [
      'v.id',
      'v.title',
      'v.numberOfViews',
      'v.url',
      'v.ratings',
      'v.workoutLevel',
      'v.duration',
      'v.durationsVideo',
      'v.createdAt',
      'c.title',
      'c.id',
      'ch.id',
      'ch.numberOfFollowers',
      'ch.image',
      'ch.name',
      'ch.isBlueBadge',
      'ch.isPinkBadge',
    ];
    const topVideos7days = await this.topView7Day();
    const followerVideo = await this.followedVideo(userId);
    const recentWatchedVideo = await this.recentWatchedVideo(userId);

    const videoMap = new Map();

    const recentWatchedVideoIds = recentWatchedVideo.map((video) => video.id);
    const topVideos7daysIds = topVideos7days.map((video) => video.id);
    const followerVideoIds = followerVideo.map((video) => video.id);

    topVideos7daysIds.forEach((videoId) => {
      videoMap.set(videoId, { videoId, value: 1 });
    });

    followerVideoIds.forEach((videoId) => {
      if (videoMap.has(videoId)) {
        const existingEntry = videoMap.get(videoId);
        videoMap.set(videoId, { videoId, value: existingEntry.value + 1 });
      } else {
        videoMap.set(videoId, { videoId, value: 1 });
      }
    });

    const mergedVideos = Array.from(videoMap.values());

    const videosWithValue2 = [];
    const videosWithValue1 = [];

    mergedVideos.forEach((entry) => {
      if (entry.value === 2) {
        videosWithValue2.push(entry.videoId);
      } else if (entry.value === 1) {
        videosWithValue1.push(entry.videoId);
      }
    });
    const [recentVideoByUser, priorityHigh, priorityLow] = await Promise.all([
      this.getVideoByIds(recentWatchedVideoIds, selected),
      this.getVideoByIds(videosWithValue2, selected),
      this.getVideoByIds(videosWithValue1, selected),
    ]);
    const ignoreIds = [...videosWithValue2, ...videosWithValue1, ...recentWatchedVideoIds];
    let temp = [...recentVideoByUser, ...priorityHigh, ...priorityLow];
    let result = [...new Map(temp.map((item) => [item.id, item])).values()];

    if (result.length >= 32) {
      result = result.slice(0, 31);
    }

    const limitVideoOther = 32 - result.length;
    if (limitVideoOther > 0) {
      let topViewVideo = await this.videoRepository.find({
        take: limitVideoOther,
        where: {
          id: Not(In(ignoreIds)),
          channel: {
            id: Not(foundChannel ? foundChannel.id : null),
          },
          isPublish: true,
        },
        order: {
          numberOfViews: 'DESC',
          ratings: 'DESC',
          createdAt: 'desc',
        },
        relations: {
          category: true,
          channel: true,
        },
      });
      result = [...result, ...topViewVideo];
    }
    const updateResult = await Promise.all(
      result.map(async (video) => {
        const [thumbnail] = await Promise.all([this.thumbnailService.getSelectedThumbnail(video.id)]);

        return {
          ...video,
          thumbnailURL: thumbnail?.image,
        };
      }),
    );
    return updateResult;
  }

  async getVideoByIds(videoIds: number[], selected: string[]) {
    if (videoIds.length === 0) {
      return []; // Nếu videoIds rỗng, trả về mảng rỗng
    }
    return await this.videoRepository
      .createQueryBuilder('v')
      .leftJoinAndSelect('v.category', 'c')
      .leftJoin('v.channel', 'ch')
      .select(selected)
      .where('v.id IN (:...videoIds)', { videoIds })
      .orderBy('v.numberOfViews', 'DESC')
      .addOrderBy('v.createdAt', 'DESC')
      .getMany();
  }

  async youMayLikeWithOutLogin() {
    let result = await this.topView7Day();
    const resultId = result.map((obj) => {
      return obj.id;
    });
    const limitVideoOther = 32 - result.length;
    if (limitVideoOther > 0) {
      let topViewVideo = await this.videoRepository.find({
        take: limitVideoOther,
        where: { id: Not(In(resultId)) },
        order: {
          numberOfViews: 'DESC',
        },
        relations: {
          channel: true,
          category: true,
        },
      });
      result = [...result, ...topViewVideo];
    }
    const updateResult = await Promise.all(
      result.map(async (video) => {
        const [thumbnail] = await Promise.all([this.thumbnailService.getSelectedThumbnail(video.id)]);
        return {
          ...video,
          thumbnailURL: thumbnail?.image,
        };
      }),
    );
    return updateResult;
  }

  async getChannelsUserFollow(userId: number) {
    return await this.channelRepository
      .createQueryBuilder('ch')
      .innerJoin('follows', 'f', 'ch.id = f.channelId')
      .where('f.userId = :userId', { userId })
      .orderBy('f.createdAt', 'DESC')
      .select([
        'ch.id',
        'ch.name',
        'ch.bio',
        'ch.image',
        'ch.isBlueBadge',
        'ch.isPinkBadge',
        'ch.numberOfFollowers',
        'f.createdAt',
      ])
      .getMany();
  }
}
