import { Video } from '@/entities/video.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import {
  FindOneOptions,
  FindOptionsOrder,
  FindOptionsRelations,
  FindOptionsWhere,
  In,
  Not,
  Repository,
} from 'typeorm';
import { PaginationDto } from './dto/request/pagination.dto';
import { UploadVideoDTO } from './dto/upload-video.dto';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { DurationType } from '@/entities/enums/durationType.enum';
import { Follow } from '@/entities/follow.entity';
import { Channel } from '@/entities/channel.entity';

@Injectable()
export class VideoRepository {
  constructor(
    @InjectRepository(Video) private readonly videoRepository: Repository<Video>,
    @InjectRepository(Follow)
    private readonly followRepository: Repository<Follow>,
  ) {}

  async findAndCount(
    channelId: number,
    paginationDto: PaginationDto,
    order: FindOptionsOrder<Video> = {},
    relations: FindOptionsRelations<Video> = {},
    withDeleted: boolean = false,
  ): Promise<[Video[], number]> {
    return await this.videoRepository.findAndCount({
      where: {
        channel: {
          id: channelId,
        },
      },
      order,
      skip: PaginationDto.getSkip(paginationDto.take, paginationDto.page),
      take: paginationDto.take,
      relations,
      withDeleted,
    });
  }

  async createVideo(channelId: number, dto: UploadVideoDTO, isComment: boolean, isPublish: boolean) {
    const newVideo = this.videoRepository.create({
      category: {
        id: dto.category,
      },
      channel: {
        id: channelId,
      },
      workoutLevel: dto.workoutLevel,
      duration: dto.duration,
      keywords: dto.keywords || null,
      isCommentable: isComment,
      isPublish: isPublish,
      url: dto.url,
      title: dto.title,
      durationsVideo: dto.durationsVideo,
    });

    return await this.videoRepository.save(newVideo);
  }

  async findVideoById(videoId: number): Promise<Video | null> {
    return await this.videoRepository.findOne({ where: { id: videoId } });
  }

  async save(video: Video): Promise<Video> {
    return await this.videoRepository.save(video);
  }

  async deleteVideos(videoIds: number[]) {
    await this.videoRepository.manager.transaction(async (transactionalEntityManager) => {
      await Promise.all(
        videoIds.map(async (videoId) => {
          await transactionalEntityManager
            .getRepository(Video)
            .findOneOrFail({ where: { id: videoId }, withDeleted: false });
          await transactionalEntityManager.getRepository(Video).softDelete(videoId);
        }),
      );
    });
  }

  async restoreVideos(videoIds: number[]) {
    await this.videoRepository.manager.transaction(async (transactionalEntityManager) => {
      await Promise.all(
        videoIds.map(async (videoId) => {
          await transactionalEntityManager.getRepository(Video).restore(videoId);
        }),
      );
    });
  }

  async findOne(
    videoId: number,
    relations: FindOptionsRelations<Video> = {},
    options: FindOneOptions<Video> = {},
  ) {
    return await this.videoRepository.findOne({
      where: { id: videoId },
      relations,
      withDeleted: options.withDeleted,
    });
  }

  async findVideoUrlById(videoId: number): Promise<string> {
    const video = await this.videoRepository.findOne({
      where: { id: videoId },
      select: ['url'],
    });
    return video ? video.url : null;
  }

  async find(
    channelId: number,
    queries: FindOptionsWhere<Video> = {},
    order: FindOptionsOrder<Video> = {},
    relations: FindOptionsRelations<Video> = {
      category: true,
      channel: true,
    },
    withDeleted: boolean = false,
  ): Promise<[Video[], number]> {
    return await this.videoRepository.findAndCount({
      where: {
        channel: {
          id: channelId,
        },
        ...queries,
      },
      order,
      relations,
      withDeleted,
    });
  }
  async getVideos() {
    return await this.videoRepository.find();
  }

  async findVideoAndAlso(videoId: number, userId?: number) {
    const selectFields = {
      channel: {
        id: true,
        image: true,
        name: true,
        isBlueBadge: true,
        isPinkBadge: true,
      },
      category: {
        id: true,
        title: true,
      },
    };

    const relations = ['category', 'channel', 'thumbnails'];

    const videoDetails = await this.videoRepository.findOne({
      where: { id: videoId },
      relations,
      select: selectFields,
    });

    const watchAlso = await this.videoAlsoChannelCategory(
      selectFields,
      videoDetails,
      videoId,
      relations,
      userId,
    );

    const {
      thumbnails,
      numberOfComments,
      channel,
      numberOfViews,
      isPublish,
      shareCount,
      urlS3,
      ...dataVideoDetails
    } = videoDetails;

    const thumbnailURL = videoDetails.thumbnails.filter((thumbnail) => thumbnail.selected)[0]?.image;
    const channelIds = await this.getFollowedChannelsByUser(userId);
    const isFollowed = !!channelIds.find((id) => id == videoDetails.channel.id);
    return {
      ...dataVideoDetails,
      thumbnailURL,
      numberOfViews: +numberOfViews,
      channel: { ...channel, isFollowed },
      watchAlso,
    };
  }

  async videoAlsoChannelCategory(
    selectFields: any,
    videoDetails: Video,
    videoId: number,
    relations: any,
    userId?: number,
  ) {
    const { channel, category, duration, workoutLevel } = videoDetails;
    const limit = 4;
    const totalVideo = 20;
    let options: any;

    const channelFollow = await this.getFollowedChannelsByUser(userId);
    const channelIds = userId ? [...channelFollow, channel.id] : [channel.id];

    options = {
      categoryId: category.id,
      channelId: channelIds,
      workoutLevel: workoutLevel,
    };
    let initialVideos = await this.findVideoByOptions([videoId], relations, selectFields, limit, options);

    let results = [...initialVideos];
    let ignoreIds: number[] = [...results.map((video) => video.id), videoId];

    const limitVideoCategoryChannelDuration = 2 * limit - results.length;
    options = {
      categoryId: category.id,
      channelId: channelIds,
      duration: duration,
    };
    const moreCategoryChannelDuration = await this.findVideoByOptions(
      ignoreIds,
      relations,
      selectFields,
      limitVideoCategoryChannelDuration,
      options,
    );
    results = results.concat(moreCategoryChannelDuration);

    ignoreIds = [...results.map((video) => video.id), videoId];
    const limitVideoCategoryChannel = 3 * limit - results.length;
    options = { categoryId: category.id, channelId: channelIds };
    const moreCategoryChannel = await this.findVideoByOptions(
      ignoreIds,
      relations,
      selectFields,
      limitVideoCategoryChannel,
      options,
    );
    results = results.concat(moreCategoryChannel);

    ignoreIds = [...results.map((video) => video.id), videoId];
    const limitVideoCategory = 4 * limit - results.length;
    options = { categoryId: category.id };
    const moreCategoryVideos = await this.findVideoByOptions(
      ignoreIds,
      relations,
      selectFields,
      limitVideoCategory,
      options,
    );

    results = results.concat(moreCategoryVideos);

    ignoreIds = [...results.map((video) => video.id), videoId];
    options = { channelId: channelIds };
    const limitVideoChannel = 5 * limit - results.length;
    const moreChannelVideos = await this.findVideoByOptions(
      ignoreIds,
      relations,
      selectFields,
      limitVideoChannel,
      options,
    );

    results = results.concat(moreChannelVideos);

    ignoreIds = [...results.map((video) => video.id), videoId];

    const limitVideoOther = totalVideo - results.length;
    if (limitVideoOther > 0) {
      const videoOthers = await this.videoRepository.find({
        take: limitVideoOther,
        relations,
        select: selectFields,
        where: { id: Not(In(ignoreIds)) },
        order: {
          numberOfViews: 'DESC',
        },
      });
      const videoOtherResponse = videoOthers.map((video) => {
        const {
          thumbnails,
          numberOfComments,
          numberOfViews,
          isPublish,
          shareCount,
          urlS3,
          ...dataVideoDetails
        } = video;
        const thumbnailURL = video.thumbnails.filter((thumbnail) => thumbnail.selected)[0]?.image;
        return {
          ...dataVideoDetails,
          numberOfViews: +numberOfViews,
          thumbnailURL,
        };
      });
      results = results.concat(videoOtherResponse);
    }

    return results;
  }

  async findVideoByOptions(
    ignoreIds: number[],
    relations: any,
    selectFields: any,
    limit: number,
    options: any,
  ) {
    const videos = await this.videoRepository.find({
      where: {
        channel: options.channelId ? { id: In(options.channelId) } : undefined,
        category: options.categoryId ? { id: options.categoryId } : undefined,
        duration: options.duration ? options.duration : undefined,
        workoutLevel: options.workoutLevel ? options.workoutLevel : undefined,
        id: Not(In(ignoreIds)),
      },
      relations,
      select: selectFields,
      take: limit,
    });

    const videoResponse = videos.map((video) => {
      const {
        thumbnails,
        numberOfComments,
        numberOfViews,
        isPublish,
        shareCount,
        urlS3,
        ...dataVideoDetails
      } = video;
      const thumbnailURL = video.thumbnails.filter((thumbnail) => thumbnail.selected)[0]?.image;
      return {
        ...dataVideoDetails,
        numberOfViews: +numberOfViews,
        thumbnailURL,
      };
    });

    return videoResponse;
  }

  async getFollowedChannelsByUser(userId: number): Promise<number[]> {
    const follows = await this.followRepository.find({
      where: { user: { id: userId } },
      relations: ['channel'],
    });

    return follows.map((follow) => follow.channel?.id);
  }
}
