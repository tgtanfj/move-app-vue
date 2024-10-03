import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { ApiConfigService } from '../../shared/services/api-config.service';
import { UploadVideoDTO } from './dto/upload-video.dto';
import { VideoRepository } from './video.repository';
import sizeOf from 'image-size';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { AwsS3Service } from '@/shared/services/aws-s3.service';
import { CategoryService } from '../category/category.service';
import { VimeoService } from '@/shared/services/vimeo.service';
import { CommentService } from '../comment/comment.service';
import { WatchingVideoHistoryService } from '../watching-video-history/watching-video-history.service';
import { ChannelService } from '../channel/channel.service';
import { PaginationDto } from './dto/request/pagination.dto';
import { plainToInstance } from 'class-transformer';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { PaginationMetadata } from './dto/response/pagination.meta';
import { VideoDetail } from './dto/response/video-detail.dto';
import { CategoryVideoDetailDto } from '../category/dto/response/category-video-detail.dto';
import { EditVideoDTO } from './dto/edit-video.dto';
import { CategoryRepository } from '../category/caregory.repository';
import { Video } from '@/entities/video.entity';
import { ThumbnailService } from '../thumbnail/thumbnail.service';
import { parseInt } from 'lodash';
import { stringToBoolean } from '@/shared/utils/stringToBool.util';
import { OPTION, URL_SHARING_CONSTRAINT } from '@/shared/constraints/sharing.constraint';
import { OptionSharingDTO } from './dto/option-sharing.dto';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';

@Injectable()
export class VideoService {
  constructor(
    private apiConfig: ApiConfigService,
    private categoryService: CategoryService,
    private s3: AwsS3Service,
    private videoRepository: VideoRepository,

    private vimeoService: VimeoService,
    private readonly categoryRepository: CategoryRepository,
    private readonly commentService: CommentService,
    private readonly watchingVideoHistoryService: WatchingVideoHistoryService,
    private readonly channelService: ChannelService,
    private readonly thumbnailService: ThumbnailService,
    @InjectQueue('upload-s3') private readonly uploadS3Queue: Queue,
  ) {}

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
  async getVideosDashboard(
    // userId: number,
    paginationDto: PaginationDto,
  ): Promise<object> {
    try {
      // const channel = await this.channelService.getChannelByUserId(userId);
      const channel = await this.channelService.findOne(2); // Hard code get auto channel of Id = 2

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

          const [selectedThumbnail, numberOfViews, numberOfComments, ratings] = await Promise.all([
            this.thumbnailService.getSelectedThumbnail(video.id),
            this.watchingVideoHistoryService.getNumberOfViews(video.id),
            this.commentService.getNumberOfComments(video.id),
            this.watchingVideoHistoryService.getAverageRating(video.id),
          ]);

          videoDetail.thumbnail_url = selectedThumbnail.image;
          videoDetail.numberOfViews = numberOfViews;
          videoDetail.numberOfComments = numberOfComments;
          videoDetail.ratings = ratings;

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
    videoFile: Express.Multer.File,
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
    // const urlS3 = await this.s3.uploadImage(videoFile)
    // console.log(urlS3);
    // if (!urlS3) {
    //   throw new Error('upload s3 fail')
    // }
    
    // await this.uploadVideoUrlS3(video.id, urlS3);
    await this.uploadS3Queue.add('upload', {
      file: videoFile,
      videoId:video.id
    })
    return video;
  }

  async editVideo(videoId: number, dto: EditVideoDTO, thumbnail: Express.Multer.File): Promise<Video> {
    try {
      // Find video by id
      const video = await this.videoRepository.findVideoById(videoId);
      if (!video) {
        throw new NotFoundException({
          message: ERRORS_DICTIONARY.NOT_FOUND_VIDEO,
        });
      }
      console.log('dto', dto);

      if (dto.categoryId) {
        const category = await this.categoryRepository.findCategoryById(dto.categoryId);
        if (!category) {
          throw new NotFoundException({
            message: ERRORS_DICTIONARY.NOT_FOUND_CATEGORY,
          });
        }
        video.category = category;
      }

      // if (thumbnail) {
      //   const thumbnailUrl = await this.s3.uploadImage(thumbnail);
      //   video.thumbnail_url = thumbnailUrl;
      // }

      // Update video properties
      video.title = dto.title || video.title;
      video.workoutLevel = dto.workoutLevel || video.workoutLevel;
      video.duration = dto.duration || video.duration;
      video.keywords = dto.keywords || video.keywords;
      video.isCommentable = dto.isCommentable !== undefined ? dto.isCommentable : video.isCommentable;

      // Save updated video
      const updatedVideo = await this.videoRepository.save(video);
      if (!updatedVideo) {
        throw new BadRequestException({
          message: ERRORS_DICTIONARY.UPDATE_VIDEO_FAIL,
        });
      }

      return updatedVideo;
    } catch (error) {
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

        await this.vimeoService.delete(url);
      } catch (error) {
        return;
      }
    });
  }

  async restoreVideos(videoIds: number[]) {
    await this.videoRepository.restoreVideos(videoIds);
  }
  async downloadVideo(linkS3: string) {
    return await this.s3.getVideoDownloadLink('images/d5297b10-8135-11ef-9482-69a9835ce969.mp4');
  }

  async findOneOrThrow(videoId: number) {
    const foundVideo = await this.videoRepository.findVideoById(videoId)
    if (!foundVideo) {
      throw new NotFoundException({
        message:ERRORS_DICTIONARY.NOT_FOUND_VIDEO
      })
    }
    return foundVideo
  }

  async uploadVideoUrlS3(videoId: number, urlS3: string) {
    const foundVideo = await this.findOneOrThrow(videoId)
    foundVideo.urlS3 = urlS3
    return await this.videoRepository.save(foundVideo)
  }
}
