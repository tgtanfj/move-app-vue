import { WatchingVideoHistory } from '@/entities/watching-video-history.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
export class WatchingVideoHistoryRepository {
  constructor(
    @InjectRepository(WatchingVideoHistory)
    private readonly watchingVideoHistoryRepository: Repository<WatchingVideoHistory>,
  ) {}

  async findAllByVideoId(videoId: number): Promise<WatchingVideoHistory[]> {
    return await this.watchingVideoHistoryRepository.find({
      where: { video: { id: videoId } },
    });
  }
}
