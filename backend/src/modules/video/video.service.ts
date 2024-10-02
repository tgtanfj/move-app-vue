import { BadRequestException, Injectable, Logger } from '@nestjs/common';
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

@Injectable()
export class VideoService {
  constructor(
    private apiConfig: ApiConfigService,
    private categoryService: CategoryService,
    private s3: AwsS3Service,
    private videoRepository: VideoRepository,
    private vimeoService: VimeoService,
    private readonly commentService: CommentService,
    private readonly watchingVideoHistoryService: WatchingVideoHistoryService,
    private readonly channelService: ChannelService,
  ) {}

  async getVideosDashboard(userId: number, paginationDto: PaginationDto): Promise<object> {
    try {
      // const channel = await this.channelService.getChannelByUserId(1); // Hard Code get auto channel of userId = 1
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

          const [numberOfViews, numberOfComments, ratings] = await Promise.all([
            this.watchingVideoHistoryService.getNumberOfViews(video.id),
            this.commentService.getNumberOfComments(video.id),
            this.watchingVideoHistoryService.getAverageRating(video.id),
          ]);

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

  async uploadVideo(channelId: number, thumbnail: Express.Multer.File, dto: UploadVideoDTO) {
    //find channel by id
    const foundChannel = null;
    //validation thumbnail
    const dimensions = sizeOf(thumbnail.buffer);
    if (dimensions.height < 720) {
      throw new BadRequestException({
        message: ERRORS_DICTIONARY.UPLOAD_THUMBNAIL_FAIL,
      });
    }
    // upload thumbnail into S3
    const linkThumbNail = await this.s3.uploadImage(thumbnail);

    dto.url = `${this.apiConfig.getString('VIMEO_API_URL')}${dto.url}`;
    const video = await this.videoRepository.createVideo(2, linkThumbNail, dto);
    if (!video) {
      throw new BadRequestException({
        message: ERRORS_DICTIONARY.UPLOAD_VIDEO_FAIL,
      });
    }
    return video;
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
}
