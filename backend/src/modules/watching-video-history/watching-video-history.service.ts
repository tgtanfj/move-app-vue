import { Injectable } from '@nestjs/common';
import { WatchingVideoHistoryRepository } from './watching-video-history.repository';

@Injectable()
export class WatchingVideoHistoryService {
  constructor(private readonly watchingVideoHistoryRepository: WatchingVideoHistoryRepository) {}

  async getAverageRating(videoId: number): Promise<number> {
    const watchingVideoHistories = await this.watchingVideoHistoryRepository.findAllByVideoId(videoId);

    if (!watchingVideoHistories.length) {
      return 0;
    }

    const totalRating = watchingVideoHistories.reduce((sum, history) => sum + history.rate, 0);
    const avgRating = totalRating / watchingVideoHistories.length;

    return avgRating;
  }

  async getNumberOfViews(videoId: number): Promise<number> {
    const watchingVideoHistories = await this.watchingVideoHistoryRepository.findAllByVideoId(videoId);

    const totalViews = watchingVideoHistories.reduce((sum, history) => sum + history.times, 0);

    return totalViews;
  }
}
