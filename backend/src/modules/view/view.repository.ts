import { Views } from '@/entities/views.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual } from 'typeorm';
import { CreateUpdateViewDto } from './dto/create-update-view.dto';
import { VideoViewHistorys } from '@/entities/video-view-history.entity';

export class ViewRepository {
  constructor(
    @InjectRepository(Views) private viewRepository: Repository<Views>,
    @InjectRepository(VideoViewHistorys) private videoViewHistoryRepository: Repository<VideoViewHistorys>,
  ) {}
  async getTotalView(time: Date, videoId: number) {
    const sum = await this.viewRepository.sum('totalView', {
      createdAt: MoreThanOrEqual(time),
      video: {
        id: videoId,
      },
    });
    return sum;
  }

  async createUpdateViewDate(dto: CreateUpdateViewDto) {
    const { videoId, date, viewTime } = dto;
    const existingView = await this.viewRepository.findOne({
      where: { video: { id: videoId }, viewDate: date },
    });
    if (!existingView) {
      const view = this.viewRepository.create({
        video: { id: videoId },
        viewDate: date,
        totalView: 1,
        totalViewTime: viewTime,
      });
      await this.viewRepository.save(view);
      return view;
    }
    !viewTime && existingView.totalView++;
    viewTime && (existingView.totalViewTime = +existingView.totalViewTime + viewTime);

    await this.viewRepository.save(existingView);
    return existingView;
  }

  async createUpdateVideoViewDate(dto: CreateUpdateViewDto) {
    const { videoId, date, viewTime } = dto;
    const existingView = await this.videoViewHistoryRepository.findOne({
      where: { video: { id: videoId }, viewDate: date },
    });
    if (!existingView) {
      const view = this.videoViewHistoryRepository.create({
        video: { id: videoId },
        viewDate: date,
        views: 1,
        totalViewTime: viewTime,
      });
      await this.videoViewHistoryRepository.save(view);
      return view;
    }
    !viewTime && existingView.views++;
    viewTime && (existingView.totalViewTime = +existingView.totalViewTime + viewTime);

    await this.videoViewHistoryRepository.save(existingView);
    return existingView;
  }
}
