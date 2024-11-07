import { Views } from '@/entities/views.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual } from 'typeorm';
import { CreateUpdateViewDto } from './dto/create-update-view.dto';

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

  async createUpdateViewDate(dto: CreateUpdateViewDto, timeCountView: number) {
    const { videoId, date, viewTime } = dto;
    const existingView = await this.viewRepository.findOne({
      where: { video: { id: videoId }, viewDate: date },
    });
    if (!existingView) {
      const view = this.viewRepository.create({
        video: { id: videoId },
        viewDate: date,
        totalView: 1,
        totalViewTime: timeCountView,
      });
      await this.viewRepository.save(view);
      return view;
    }
    if (viewTime) {
      existingView.totalViewTime = +existingView.totalViewTime + viewTime - timeCountView;
    } else {
      existingView.totalView++ && (existingView.totalViewTime = +existingView.totalViewTime + timeCountView);
    }

    await this.viewRepository.save(existingView);
    return existingView;
  }

  async getSecondWatchByTime(videoId: number, time: Date) {
    return await this.viewRepository.sum('totalViewTime', {
      createdAt: MoreThanOrEqual(time),
      video: {
        id: videoId,
      },
    });
  }
}
