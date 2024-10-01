import { ChannelRepository } from './../channel/channel.repository';
import { Injectable, Logger, BadRequestException, ConsoleLogger, NotFoundException } from '@nestjs/common';
import { VideoRepository } from './video.repository';
import { PaginationDto } from './dto/request/pagination.dto';
import { CommentRepository } from '../comment/comment.repository';
import { WatchingVideoHistoryRepository } from '../watching-video-history/watching-video-history.repository';
import { VideoDetail } from './dto/response/video-detail.dto';
import { plainToInstance } from 'class-transformer';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { PaginationMetadata } from './dto/response/pagination.meta';
import { CategoryVideoDetailDto } from '../category/dto/response/category-video-detail.dto';
import { CommentService } from '../comment/comment.service';
import { WatchingVideoHistoryService } from '../watching-video-history/watching-video-history.service';
import { ChannelService } from '../channel/channel.service';

@Injectable()
export class VideoService {
  constructor(
    private readonly videoRepository: VideoRepository,
    private readonly commentService: CommentService,
    private readonly watchingVideoHistoryService: WatchingVideoHistoryService,
    private readonly channelService: ChannelService,
  ) {}

  async getVideosDashboard(userId: number, paginationDto: PaginationDto): Promise<object> {
    try {
      const channel = await this.channelService.getChannelByUserId(1); // Hard Code get auto channel of userId = 1

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
}
