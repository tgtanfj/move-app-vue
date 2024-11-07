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
import { channel } from 'diagnostics_channel';
import { OrderBy } from '../channel/dto/request/filter-video-channel.dto';

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
      channel: { ...channel, isFollowed: userId && isFollowed },
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

  async getUserIdsFollowedByChannelId(channelId: number): Promise<number[]> {
    const follows = await this.followRepository.find({
      where: { channel: { id: channelId } },
      relations: ['user'],
    });

    return follows.map((follow) => follow.user?.id);
  }

  async overviewAnalyticVideo(videoId: number, time: string) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin('v.views', 'view')
      .leftJoin('v.donations', 'donation')
      .innerJoin('v.category', 'category')
      .where('v.id = :videoId', { videoId: videoId })
      .andWhere('donation.createdAt >= :timeDonation', { timeDonation: time })
      .andWhere('view.viewDate >= :timeView', { timeView: time })
      .select(['v.id', 'v.title', 'category.title', 'v.ratings', 'v.shareCount'])
      .addSelect('sum(view."totalView")', 'numberOfViews')
      .getRawOne();
    return result;
  }

  async getNumberOfRepByTime(videoId: number, time: string) {
    const sum = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin('donations', 'd', 'v.id = d.videoId')
      .leftJoin('gift-packages', 'g', 'd.giftPackageId = g.id')
      .select('CAST(SUM(g."numberOfREPs") AS BIGINT) as totalREPs')
      .where('v.id = :videoId', { videoId })
      .andWhere('d."createdAt" >= :time', { time })
      .groupBy('v.id')
      .getRawOne();

    return sum;
  }

  async getVideoViewersByAgeGroups(videoId: number, time: string) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin('watching-video-histories', 'wvh', 'v.id = wvh.videoId')
      .leftJoin('users', 'u', 'wvh.userId = u.id')
      .select([
        `CASE
        WHEN EXTRACT(YEAR FROM AGE(u."dateOfBirth")) BETWEEN 18 AND 24 THEN '18 - 24'
        WHEN EXTRACT(YEAR FROM AGE(u."dateOfBirth")) BETWEEN 25 AND 34 THEN '25 - 34'
        WHEN EXTRACT(YEAR FROM AGE(u."dateOfBirth")) BETWEEN 35 AND 44 THEN '35 - 44'
        WHEN EXTRACT(YEAR FROM AGE(u."dateOfBirth")) BETWEEN 45 AND 54 THEN '45 - 54'
        WHEN EXTRACT(YEAR FROM AGE(u."dateOfBirth")) BETWEEN 55 AND 64 THEN '55 - 64'
        WHEN EXTRACT(YEAR FROM AGE(u."dateOfBirth")) > 64 THEN '64 above'
        ELSE 'Unknown'
      END AS age_group`,
        'COUNT(u.id) AS total_count',
      ])
      .where('v.id = :videoId', { videoId })
      .andWhere('wvh.createdAt >= :time', { time: time })
      .groupBy('age_group')
      .getRawMany();

    return result;
  }

  async getVideoViewersByGenderGroups(videoId: number, time: string) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin('watching-video-histories', 'wvh', 'v.id = wvh.videoId')
      .leftJoin('users', 'u', 'wvh.userId = u.id')
      .select([
        `CASE
        WHEN u.gender = 'M' THEN 'Male'
        WHEN u.gender = 'F' THEN 'Female'
        WHEN u.gender = 'O' THEN 'Other'
        ELSE 'Unknown'
      END AS gender_group`,
        'COUNT(u.id) AS total_count',
      ])
      .addSelect('')
      .where('v.id = :videoId', { videoId })
      .andWhere('wvh.createdAt >= :time', { time })
      .groupBy('gender_group')
      .getRawMany();

    return result;
  }

  async getTotalViewOfChannel(channelId: number) {
    const result = await this.videoRepository.sum('numberOfViews', {
      channel: {
        id: channelId,
      },
    });
    return result;
  }

  async getLastVideoOfChannel(channelId: number) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .where('v.channelId = :channelId', { channelId: channelId })
      .select(['v.id', 'v.title', 'v.ratings', 'v.numberOfViews'])
      .orderBy('v.createdAt', 'DESC')
      .take(1)
      .getOne();
    return result;
  }

  async getOwnerVideo(videoId: number) {
    return await this.videoRepository.findOne({
      where: { id: videoId },
      relations: ['channel', 'channel.user'],
      select: {
        id: true,
        title: true,
        channel: {
          id: true,
          user: {
            id: true,
            avatar: true,
            username: true,
          },
        },
      },
    });
  }

  async findAll(relations?: FindOptionsRelations<Video>) {
    return await this.videoRepository.find({
      relations,
    });
  }
  async getMostViewerNationality(videoId: number, time: string) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin('watching-video-histories', 'wvh', 'v.id = wvh.videoId')
      .leftJoin('users', 'u', 'wvh.userId = u.id')
      .leftJoin('countries', 'c', 'u.countryId = c.id')
      .select([
        `COALESCE(c.id::TEXT, 'Unknown') AS country_id`,
        `COALESCE(c.name, 'Unknown') AS country_name`,
        'COUNT(u.id) AS total_users',
      ])
      .where('v.id = :videoId', { videoId })
      .andWhere('wvh.createdAt >= :time', { time })
      .groupBy('country_id,country_name')
      .orderBy('total_users', 'DESC')
      .getRawMany();

    return result;
  }

  async getVideoViewersByState(videoId: number, time: string, countryId: number) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin('watching-video-histories', 'wvh', 'v.id = wvh.videoId')
      .leftJoin('users', 'u', 'wvh.userId = u.id')
      .leftJoin('states', 's', 'u.stateId = s.id')
      .select(['COALESCE(s.id, 0) AS state_id', 'COUNT(u.id) AS total_users', 's.name as state_name'])
      .where('v.id = :videoId', { videoId })
      .andWhere('u.countryId = :countryId', { countryId })
      .andWhere('wvh.createdAt >= :time', { time })
      .groupBy('s.id, s.name')
      .orderBy('total_users', 'DESC')
      .getRawMany();

    return result;
  }

  async getVideoAnalytics(
    channelId: number,
    time: string,
    orderBy: OrderBy = { field: 'number_of_views', direction: 'DESC' },
    limit: number = 10,
    offset: number = 0,
  ) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin(
        (qb) =>
          qb
            .select([
              'vw.videoId AS videoId',
              'SUM(vw.totalViewTime) AS total_seconds',
              'SUM(vw.totalView) AS total_views',
            ])
            .from('views', 'vw')
            .groupBy('vw.videoId'),
        'vw_summary',
        'vw_summary.videoId = v.id',
      )
      .leftJoin('donations', 'd', 'v.id = d.videoId')
      .leftJoin(
        (qb) =>
          qb
            .select(['d.videoId AS videoId', 'SUM(g.numberOfREPs) AS total_reps'])
            .from('gift-packages', 'g')
            .leftJoin('donations', 'd', 'd.giftPackageId = g.id')
            .where('g.deletedAt IS NULL')
            .groupBy('d.videoId'),
        'g_summary',
        'g_summary.videoId = v.id',
      )
      .leftJoin('watching-video-histories', 'wvh', 'v.id = wvh.videoId')
      .leftJoin('categories', 'c', 'v.categoryId = c.id')
      .select([
        'v.id AS video_id',
        'v.title AS video_title',
        'v.ratings AS video_ratings',
        'v.durationsVideo as video_duration',
        'v.numberOfViews AS number_of_views',
        'v.createdAt as created_at',
        'COUNT(DISTINCT d."userId") AS total_donators',
        'COUNT(*) OVER() AS total_count',
        'c.title AS category_title',
      ])
      .addSelect('COALESCE(vw_summary.total_seconds, 0)', 'total_seconds')
      .addSelect('COALESCE(vw_summary.total_views, 0)', 'total_views')
      .addSelect('COALESCE(g_summary.total_reps, 0)', 'total_reps')
      .where('v.channelId = :channelId', { channelId })
      .groupBy(
        'v.id, v.title, v.ratings, v.numberOfViews, c.title, vw_summary.total_seconds, vw_summary.total_views, g_summary.total_reps',
      )
      .orderBy(`${orderBy.field}`, `${orderBy.direction}`, 'NULLS LAST')
      .limit(limit)
      .offset(offset)
      .getRawMany();

    return {
      totalCount: result[0]?.total_count || 0,
      result,
    };
  }

  async getVideoAnalyticByQuery(
    channelId: number,
    time: string,
    orderBy: OrderBy = { field: 'number_of_views', direction: 'DESC' },
    limit: number = 10,
    offset: number = 0,
  ) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin(
        (qb) =>
          qb
            .select([
              'vw.videoId AS videoId',
              'SUM(vw.totalViewTime) AS total_seconds',
              'SUM(vw.totalView) AS total_views',
            ])
            .from('views', 'vw')
            .groupBy('vw.videoId'),
        'vw_summary',
        'vw_summary.videoId = v.id',
      )
      .leftJoin('donations', 'd', 'v.id = d.videoId')
      .leftJoin(
        (qb) =>
          qb
            .select(['d.videoId AS videoId', 'SUM(g.numberOfREPs) AS total_reps'])
            .from('gift-packages', 'g')
            .leftJoin('donations', 'd', 'd.giftPackageId = g.id')
            .where('g.deletedAt IS NULL')
            .groupBy('d.videoId'),
        'g_summary',
        'g_summary.videoId = v.id',
      )
      .leftJoin('watching-video-histories', 'wvh', 'v.id = wvh.videoId')
      .leftJoin('categories', 'c', 'v.categoryId = c.id')
      .select([
        'v.id AS video_id',
        'v.title AS video_title',
        'v.ratings AS video_ratings',
        'v.durationsVideo as video_duration',
        'v.numberOfViews AS number_of_views',
        'v.createdAt as created_at',
        'COUNT(DISTINCT d."userId") AS total_donators',
        'COUNT(*) OVER() AS total_count',
        'c.title AS category_title',
      ])
      .addSelect('COALESCE(vw_summary.total_seconds, 0)', 'total_seconds')
      .addSelect('COALESCE(vw_summary.total_views, 0)', 'total_views')
      .addSelect('COALESCE(g_summary.total_reps, 0)', 'total_reps')
      .where('v.channelId = :channelId', { channelId })
      .andWhere('(wvh.createdAt >= :time OR d.createdAt >= :time)', { time })
      .groupBy(
        'v.id, v.title, v.ratings, v.numberOfViews, c.title, vw_summary.total_seconds, vw_summary.total_views, g_summary.total_reps',
      )
      .orderBy(`${orderBy.field}`, `${orderBy.direction}`, 'NULLS LAST')
      .limit(limit)
      .offset(offset)
      .getRawMany();

    return {
      totalCount: result[0]?.total_count || 0,
      result,
    };
  }

  async getTotalSecondsOfChannel(channelId: number) {
    const result = await this.videoRepository
      .createQueryBuilder('v')
      .leftJoin('views', 'vw', 'v.id = vw.videoId')
      .select('SUM(vw."totalViewTime")', 'total_view_time')
      .where('v.channelId = :channelId', { channelId })
      .andWhere('vw."deletedAt" IS NULL')
      .getRawOne();

    return result.total_view_time;
  }

  async getManyVideoUseIn(array: number[]) {
    return await this.videoRepository.find({
      where: {
        id: In(array),
      },
      select: {
        title: true,
        urlS3: true,
      },
    });
  }
}
