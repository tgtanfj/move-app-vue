import { WatchingVideoHistory } from '@/entities/watching-video-history.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { MoreThanOrEqual, Not, Repository } from 'typeorm';
import { RateDto } from './dto/rate.dto';
export class WatchingVideoHistoryRepository {
  constructor(
    @InjectRepository(WatchingVideoHistory)
    private readonly watchingVideoHistoryRepository: Repository<WatchingVideoHistory>,
  ) {}

  async averageRateByVideoId(videoId: number): Promise<number> {
    const averageRate = await this.watchingVideoHistoryRepository.average('rate', {
      video: { id: videoId },
      rate: Not(0),
    });
    return parseFloat(averageRate.toFixed(1));
  }

  async createOrUpdate(userId: number, videoId: number) {
    const existingWatchingVideoHistory = await this.watchingVideoHistoryRepository.findOne({
      where: { user: { id: userId }, video: { id: videoId } },
    });
    if (existingWatchingVideoHistory) {
      existingWatchingVideoHistory.times++;
      return await this.watchingVideoHistoryRepository.save(existingWatchingVideoHistory);
    } else {
      const newWatchingVideoHistory = this.watchingVideoHistoryRepository.create({
        user: { id: userId },
        video: { id: videoId },
        times: 1,
      });
      return await this.watchingVideoHistoryRepository.save(newWatchingVideoHistory);
    }
  }

  async rate(userId: number, dto?: RateDto) {
    const videoId = dto.videoId;
    const existingWatchingVideoHistory = await this.watchingVideoHistoryRepository.findOne({
      where: { user: { id: userId }, video: { id: videoId } },
    });
    existingWatchingVideoHistory.rate = dto.rate;
    return await this.watchingVideoHistoryRepository.save(existingWatchingVideoHistory);
  }

  async getMyRate(userId: number, videoId: number) {
    return await this.watchingVideoHistoryRepository.findOne({
      where: { user: { id: userId }, video: { id: videoId } },
    });
  }

  async avgRatingVideoByTime(videoId: number, time: Date) {
    const result = await this.watchingVideoHistoryRepository.average('rate', {
      video: {
        id: videoId,
      },
      rate: Not(0),
      createdAt: MoreThanOrEqual(time),
    });
    return result;
  }
}
