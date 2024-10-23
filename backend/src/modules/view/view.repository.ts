import { Views } from '@/entities/views.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual } from 'typeorm';

export class ViewRepository {
  constructor(@InjectRepository(Views) private viewRepository: Repository<Views>) {}
  async getTotalView(time: Date, videoId: number) {
    const sum = await this.viewRepository.sum('totalView', {
      createdAt: MoreThanOrEqual(time),
      video: {
        id: videoId,
      },
    });
    return sum;
  }
}
