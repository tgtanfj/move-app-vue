import { Injectable } from '@nestjs/common';
import { WatchingVideoHistoryRepository } from './watching-video-history.repository';
import { RateDto } from './dto/rate.dto';
import { VideoRepository } from '../video/video.repository';

@Injectable()
export class WatchingVideoHistoryService {
  constructor(
    private readonly watchingVideoHistoryRepository: WatchingVideoHistoryRepository,
    private readonly videoRepository: VideoRepository,
  ) {}

  async createOrUpdate(userId: number, videoId: number) {
    return await this.watchingVideoHistoryRepository.createOrUpdate(userId, videoId);
  }

  async rate(userId: number, dto?: RateDto) {
    const videoId = dto.videoId;
    const videoHistory = await this.watchingVideoHistoryRepository.rate(userId, dto);

    const [video, ratings] = await Promise.all([
      this.videoRepository.findVideoById(videoId),
      this.watchingVideoHistoryRepository.averageRateByVideoId(videoId),
    ]);

    video.ratings = ratings;
    await this.videoRepository.save(video);

    return videoHistory;
  }

  async getMyRate(userId: number, videoId: number) {
    return await this.watchingVideoHistoryRepository.getMyRate(userId, videoId);
  }

  async getRatingAvgOfVideo(videoId: number, time: Date) {
    return await this.watchingVideoHistoryRepository.avgRatingVideoByTime(videoId, time);
  }
}
