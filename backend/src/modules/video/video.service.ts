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

@Injectable()
export class VideoService {
  constructor(
    private readonly videoRepository: VideoRepository,
    private readonly commentRepository: CommentRepository,
    private readonly watchingVideoHistoryRepository: WatchingVideoHistoryRepository,
    private readonly channelRepository: ChannelRepository,
  ) {}

  async getVideosDashboard(userId: number, paginationDto: PaginationDto): Promise<object> {
    try {
      const channel = await this.channelRepository.getChannelByUserId(1); // Hard Code get auto channel of userId = 1

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

          videoDetail.numberOfViews = await this.watchingVideoHistoryRepository.getNumberOfViews(video.id);

          videoDetail.numberOfComments = await this.commentRepository.getNumberOfComment(video.id);

          videoDetail.ratings = await this.watchingVideoHistoryRepository.getAverageRating(video.id);

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
