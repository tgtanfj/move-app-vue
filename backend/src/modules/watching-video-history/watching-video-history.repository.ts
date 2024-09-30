import { WatchingVideoHistory } from '@/entities/watching-video-history.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
export class WatchingVideoHistoryRepository {
  constructor(
    @InjectRepository(WatchingVideoHistory)
    private readonly watchingVideoHistoryRepository: Repository<WatchingVideoHistory>,
  ) {}

  async getNumberOfViews(videoId: number): Promise<number> {
    const histories = await this.watchingVideoHistoryRepository.find({
      where: { video: { id: videoId } },
    });

    const totalViews = histories.reduce((sum, history) => sum + history.times, 0);
    return totalViews;
  }

  async getAverageRating(videoId: number): Promise<number> {
    const histories = await this.watchingVideoHistoryRepository.find({
      where: { video: { id: videoId } },
    });

    if (!histories.length) {
      return 0;
    }

    const totalRating = histories.reduce((sum, history) => sum + history.rate, 0);
    const avgRating = totalRating / histories.length;

    return avgRating;
  }
}
