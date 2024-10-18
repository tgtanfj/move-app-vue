import { Video } from '@/entities/video.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { OPTION, URL_SHARING_CONSTRAINT } from '@/shared/constraints/sharing.constraint';
import { AwsS3Service } from '@/shared/services/aws-s3.service';
import { VimeoService } from '@/shared/services/vimeo.service';
import { fixIntNumberResponse } from '@/shared/utils/fix-number-response.util';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { stringToBoolean } from '@/shared/utils/stringToBool.util';
import { InjectQueue } from '@nestjs/bullmq';
import { BadRequestException, forwardRef, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { Queue } from 'bullmq';
import { plainToInstance } from 'class-transformer';
import * as fs from 'fs';
import { parseInt } from 'lodash';
import * as path from 'path';
import { FindOptionsOrder } from 'typeorm';
import { ApiConfigService } from '../../shared/services/api-config.service';
import { CategoryRepository } from '../category/category.repository';
import { CategoryService } from '../category/category.service';
import { CategoryVideoDetailDto } from '../category/dto/response/category-video-detail.dto';
import { ChannelService } from '../channel/channel.service';
import { ChannelItemDto } from '../channel/dto/response/channel-item.dto';
import { ThumbnailService } from '../thumbnail/thumbnail.service';
import { WatchingVideoHistoryService } from '../watching-video-history/watching-video-history.service';
import { FilterWorkoutLevel, SortBy } from './../channel/dto/request/filter-video-channel.dto';
import { EditVideoDTO } from './dto/edit-video.dto';
import { OptionSharingDTO } from './dto/option-sharing.dto';
import { PaginationDto } from './dto/request/pagination.dto';
import { PaginationMetadata } from './dto/response/pagination.meta';
import { VideoDetail } from './dto/response/video-detail.dto';
import { VideoItemDto } from './dto/response/video-item.dto';
import { UploadVideoDTO } from './dto/upload-video.dto';
import { VideoRepository } from './video.repository';
import { ThumbnailRepository } from '../thumbnail/thumbnail.repository';

@Injectable()
export class VideoService {
  private readonly videoUploadPath = path.join(process.cwd(), 'src', 'shared', 'store');
  constructor(
    private apiConfig: ApiConfigService,
    private categoryService: CategoryService,
    private s3: AwsS3Service,
    private videoRepository: VideoRepository,
    private thumbnailRepository: ThumbnailRepository,
    private vimeoService: VimeoService,
    private readonly categoryRepository: CategoryRepository,
    private readonly watchingVideoHistoryService: WatchingVideoHistoryService,
    @Inject(forwardRef(() => ChannelService))
    private readonly channelService: ChannelService,
    private readonly thumbnailService: ThumbnailService,
    @InjectQueue('upload-s3') private readonly uploadS3Queue: Queue,
  ) {
    if (!fs.existsSync(this.videoUploadPath)) {
      fs.mkdirSync(this.videoUploadPath, { recursive: true });
    }
  }

  async sharingVideoUrlByNativeId(videoId: number): Promise<string> {
    try {
      const videoURL = await this.videoRepository.findVideoUrlById(videoId);
      if (!videoURL) {
        throw new NotFoundException({
          message: ERRORS_DICTIONARY.NOT_FOUND_VIDEO,
        });
      }
      return videoURL;
    } catch (error) {
      throw error;
    }
  }
  async sharingVideoUrlById(videoId: number, optionDTO: OptionSharingDTO): Promise<string> {
    try {
      const videoURL = await this.videoRepository.findVideoUrlById(videoId);
      if (!videoURL) {
        throw new NotFoundException({
          message: ERRORS_DICTIONARY.NOT_FOUND_VIDEO,
        });
      }
      let shareUrl: string;
      switch (optionDTO.option) {
        case OPTION.FACEBOOK:
          shareUrl = `${URL_SHARING_CONSTRAINT.FACEBOOK}${videoURL}`;

          break;
        case OPTION.TWITTER:
          shareUrl = `${URL_SHARING_CONSTRAINT.TWITTER}${videoURL}`;
          break;
        default:
          throw new Error('Unsupported sharing option');
      }

      return shareUrl;
    } catch (error) {
      throw error;
    }
  }
  async getVideosDashboard(userId: number, paginationDto: PaginationDto): Promise<object> {
    try {
      const channel = await this.channelService.getChannelByUserId(userId);

      const [videos, total] = await this.videoRepository.findAndCount(
        channel.id,
        paginationDto,
        {
          createdAt: 'DESC',
        },
        {
          category: true,
        },
      );

      const totalPages = Math.ceil(total / paginationDto.take);

      const listVideoDetail = await Promise.all(
        videos.map(async (video) => {
          const videoDetail = plainToInstance(VideoDetail, video, { excludeExtraneousValues: true });

          videoDetail.datePosted = video.createdAt.toISOString().split('T')[0];

          const selectedThumbnail = await this.thumbnailService.getSelectedThumbnail(video.id);

          videoDetail.thumbnail_url = selectedThumbnail?.image;

          videoDetail.category = plainToInstance(CategoryVideoDetailDto, video.category, {
            excludeExtraneousValues: true,
          });

          return videoDetail;
        }),
      );

      return objectResponse(
        listVideoDetail,
        new PaginationMetadata(total, paginationDto.page, paginationDto.take, totalPages),
      );
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async createUploadSession(fileSize: number) {
    try {
      //get link upload
      const response = await this.vimeoService.createUploadSession(fileSize);
      const categories = await this.categoryService.findAll();

      return {
        response,
        categories,
      };
    } catch (error) {
      throw new Error('Error creating upload session: ' + error.message);
    }
  }

  async uploadVideo(
    userId: number,
    thumbnails: Array<Express.Multer.File>,
    dto: UploadVideoDTO,
    pathVideo: string,
    videoFile?: Express.Multer.File,
  ) {
    //find channel by id
    const foundChannel = await this.channelService.getChannelByUserId(userId);
    dto.url = `${this.apiConfig.getString('VIMEO_API_URL')}${dto.url}`;
    const isPublish = stringToBoolean(dto.isPublish);
    const isComment = stringToBoolean(dto.isCommentable);

    const video = await this.videoRepository.createVideo(foundChannel.id, dto, isComment, isPublish);
    if (!video) {
      throw new BadRequestException({
        message: ERRORS_DICTIONARY.UPLOAD_VIDEO_FAIL,
      });
    }
    const selected = parseInt(dto.selectedThumbnail);
    //save thumbnails
    const newThumb = await this.thumbnailService.saveThumbnails(thumbnails, selected, video.id);
    if (!newThumb) {
      throw new BadRequestException({
        message: ERRORS_DICTIONARY.UPLOAD_VIDEO_FAIL,
      });
    }
    // await this.channelService.increaseTotalVideo(foundChannel.id);
    // await this.uploadVideoUrlS3(video.id, urlS3);
    try {
      await this.uploadS3Queue.add('upload', {
        path: pathVideo,
        videoId: video.id,
      });
    } catch (error) {
      throw new Error(error);
    }
    return video;
  }

  async editVideo(videoId: number, dto: EditVideoDTO, thumbnail: Express.Multer.File): Promise<Video> {
    try {
      const video = await this.videoRepository.findVideoById(videoId);
      if (!video) {
        throw new NotFoundException({
          message: ERRORS_DICTIONARY.NOT_FOUND_VIDEO,
        });
      }

      if (dto.categoryId) {
        const category = await this.categoryRepository.findCategoryById(dto.categoryId);
        if (!category) {
          throw new NotFoundException({
            message: ERRORS_DICTIONARY.NOT_FOUND_CATEGORY,
          });
        }
        video.category = category;
      }

      video.title = dto.title || video.title;
      video.workoutLevel = dto.workoutLevel || video.workoutLevel;
      video.duration = dto.duration || video.duration;
      video.keywords = dto.keywords || video.keywords;
      if (dto.isCommentable !== undefined) {
        if (typeof dto.isCommentable === 'string') {
          video.isCommentable = dto.isCommentable.toLowerCase() === 'true';
        } else {
          video.isCommentable = Boolean(dto.isCommentable);
        }
      }

      if (thumbnail) {
        const thumbnailUrl = await this.s3.uploadImage(thumbnail);

        await this.thumbnailService.updateThumbnail(thumbnailUrl, true, videoId);
      }

      const updatedVideo = await this.videoRepository.save(video);
      if (!updatedVideo) {
        throw new BadRequestException({
          message: ERRORS_DICTIONARY.UPDATE_VIDEO_FAIL,
        });
      }

      return await this.videoRepository.findOne(videoId, {
        thumbnails: true,
        category: true,
      });
    } catch (error) {
      console.error('Error updating video:', error);
      throw error;
    }
  }

  async deleteVideos(videoIds: number[]) {
    await this.videoRepository.deleteVideos(videoIds).catch((error) => {
      throw new BadRequestException(ERRORS_DICTIONARY.CAN_NOT_DELETE_VIDEOS);
    });

    videoIds.forEach(async (videoId) => {
      try {
        const url = (await this.videoRepository.findOne(videoId, {}, { withDeleted: true })).url;
        if (!url) return;

        // await this.vimeoService.delete(url);
      } catch (error) {
        return;
      }
    });
  }

  async restoreVideos(videoIds: number[]) {
    await this.videoRepository.restoreVideos(videoIds);
  }

  async downloadVideo(videoId: number) {
    const from = this.apiConfig.getString('DOWNLOAD_FROM');
    switch (from) {
      case 's3':
        const foundVideo = await this.findOneOrThrow(videoId);
        if (!foundVideo.urlS3) {
          return null;
        }
        return await this.s3.getVideoDownloadLink(foundVideo.urlS3, foundVideo.title);
      case 'vimeo':

      default:
        break;
    }
  }

  async findOneOrThrow(videoId: number) {
    const foundVideo = await this.videoRepository.findVideoById(videoId);
    if (!foundVideo) {
      throw new NotFoundException({
        message: ERRORS_DICTIONARY.NOT_FOUND_VIDEO,
      });
    }
    return foundVideo;
  }

  async uploadVideoUrlS3(videoId: number, urlS3: string) {
    const foundVideo = await this.findOneOrThrow(videoId);
    foundVideo.urlS3 = urlS3;
    return await this.videoRepository.save(foundVideo);
  }

  async saveVideoToServer(videoFile: Express.Multer.File): Promise<string> {
    // Generate a file path where the video will be stored
    const fileName = `${Date.now()}-${videoFile.originalname}`;
    const filePath = path.join(this.videoUploadPath, fileName);

    // Save the video to the server
    return new Promise((resolve, reject) => {
      fs.writeFile(filePath, videoFile.buffer, (err) => {
        if (err) {
          reject('Failed to save video');
        }
        resolve(filePath);
      });
    });
  }

  async getChannelVideos(channelId: number, queries: any, paginationDto: PaginationDto): Promise<object> {
    const { workoutLevel, categoryId, sortBy } = queries;

    let searchConditions: any = {
      channel: {
        id: channelId,
      },
      isPublish: true,
    };

    if (categoryId) {
      searchConditions = { ...searchConditions, category: { id: categoryId } };
    }

    if (workoutLevel && workoutLevel !== FilterWorkoutLevel.ALL_LEVEL)
      searchConditions = { ...searchConditions, workoutLevel };

    let order: FindOptionsOrder<Video> = {
      createdAt: 'DESC',
      title: 'ASC',
    };

    switch (sortBy) {
      case SortBy.MOST_RECENT:
        break;
      case SortBy.VIEWS_HIGH_TO_LOW:
        order = {
          ...order,
          numberOfViews: 'DESC',
        };
        break;
      case SortBy.VIEWS_LOW_TO_HIGH:
        order = {
          ...order,
          numberOfViews: 'ASC',
        };
        break;
      case SortBy.DURATION_HIGH_TO_LOW:
        order = {
          ...order,
          durationsVideo: 'DESC',
        };
        break;
      case SortBy.DURATION_LOW_TO_HIGH:
        order = {
          ...order,
          durationsVideo: 'ASC',
        };
        break;
      case SortBy.RATINGS_HIGH_TO_LOW:
        order = {
          ...order,
          ratings: 'DESC',
        };
        break;
      case SortBy.RATINGS_LOW_TO_HIGH:
        order = {
          ...order,
          ratings: 'ASC',
        };
        break;
      default:
        break;
    }

    const [videos, total] = await this.videoRepository.find(channelId, searchConditions, order);

    const videoItems = await Promise.all(
      videos.map(async (video) => {
        const videoItemDto = plainToInstance(VideoItemDto, video, { excludeExtraneousValues: true });

        const thumbnail = await this.thumbnailService.getSelectedThumbnail(video.id);
        videoItemDto.thumbnailURL = thumbnail?.image;

        videoItemDto.channel = plainToInstance(ChannelItemDto, video.channel, {
          excludeExtraneousValues: true,
        });

        videoItemDto.category = plainToInstance(CategoryVideoDetailDto, video.category, {
          excludeExtraneousValues: true,
        });

        videoItemDto.videoLength = Math.ceil(video.durationsVideo);

        videoItemDto.numberOfViews = +videoItemDto.numberOfViews;
        videoItemDto.channel.numberOfFollowers = +videoItemDto.channel.numberOfFollowers;

        return videoItemDto;
      }),
    ).then((sortedVideos) => {
      const startIndex = PaginationDto.getSkip(paginationDto.take, paginationDto.page);
      return sortedVideos.slice(startIndex, startIndex + paginationDto.take);
    });

    const totalPages = Math.ceil(total / paginationDto.take);

    return objectResponse(
      videoItems,
      new PaginationMetadata(total, paginationDto.page, paginationDto.take, totalPages),
    );
  }

  getMax(videos: Video[]) {
    return {
      views: Math.max(...videos.map((video) => video.numberOfViews)),
      rates: Math.max(...videos.map((video) => video.ratings)),
      comments: Math.max(...videos.map((video) => video.numberOfComments)),
    };
  }
  getMin(videos: Video[]) {
    return {
      views: Math.min(...videos.map((video) => video.numberOfViews)),
      rates: Math.min(...videos.map((video) => video.ratings)),
      comments: Math.min(...videos.map((video) => video.numberOfComments)),
    };
  }
  weightedVideo(video: Video, minValues: any, maxValues: any) {
    const normalizedViews =
      (video.numberOfViews - minValues.views) / (maxValues.views - minValues.views || 1);
    const normalizedRates = (video.ratings - minValues.rates) / (maxValues.rates - minValues.rates || 1);
    const normalizedComments =
      (video.numberOfComments - minValues.comments) / (maxValues.comments - minValues.comments || 1);

    // Trọng số cho mỗi tiêu chí
    const weightViews = 0.45;
    const weightRates = 0.35;
    const weightComments = 0.2;

    // Tính điểm tổng cho video
    const totalScore =
      normalizedViews * weightViews + normalizedRates * weightRates + normalizedComments * weightComments;

    return { ...video, totalScore };
  }
  async sortVideoByPriority() {
    console.log(this.videoUploadPath);
    const videos = await this.videoRepository.getVideos();
    const min = this.getMin(videos);
    const max = this.getMax(videos);
    const calVideos = videos.map((video) => {
      const result = this.weightedVideo(video, min, max);
      return {
        result,
      };
    });
    const sortedVideos = calVideos.sort((a: any, b: any) => b.result.totalScore - a.result.totalScore);
    return sortedVideos;
  }

  async getVideoDetails(videoId: number, userId?: number) {
    if (userId) {
      await this.watchingVideoHistoryService.createOrUpdate(userId, videoId).catch((error) => {
        throw new NotFoundException(ERRORS_DICTIONARY.NOT_CREATE_VIDEO_HISTORY);
      });
    }
    const video = await this.videoRepository.findVideoAndAlso(videoId, userId).catch((error) => {
      throw new NotFoundException(ERRORS_DICTIONARY.NOT_FOUND_VIDEO);
    });
    return video;
  }

  async findChannel(videoId: number): Promise<Video> {
    return this.videoRepository.findOne(videoId, { channel: true });
  }
}
