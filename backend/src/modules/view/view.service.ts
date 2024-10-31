import { VideoRepository } from './../video/video.repository';
import { Injectable } from '@nestjs/common';
import { ViewRepository } from './view.repository';
import { CreateUpdateViewDto } from './dto/create-update-view.dto';
import { NotificationService } from '../notification/notification.service';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { CategoryRepository } from '../category/category.repository';

@Injectable()
export class ViewService {
  constructor(
    private viewRepository: ViewRepository,
    private videoRepository: VideoRepository,
    private notificationService: NotificationService,
    private categoryRepository: CategoryRepository,
  ) {}
  async getTotalViewInOnTime(time: Date, videoId: number) {
    return await this.viewRepository.getTotalView(time, videoId);
  }

  async createUpdateViewDate(dto: CreateUpdateViewDto) {
    const video = await this.videoRepository.findOne(dto.videoId, {
      channel: { user: true },
      category: true,
    });
    const timeCountView = video?.durationsVideo * 0.7;
    const view = await this.viewRepository.createUpdateViewDate(dto, timeCountView);
    const receiver = video.channel.user.id;
    const systemId = 0;

    if (!dto.viewTime) {
      video.numberOfViews++;
      video.category.numberOfViews++;
      await this.videoRepository.save(video);
      await this.categoryRepository.save(video.category);

      const isExisted = await this.notificationService.checkNotificationExistsAntiSpam(
        receiver,
        systemId,
        +video.numberOfViews,
      );

      const isMilestone =
        Number.isInteger(Math.log10(video.numberOfViews)) && Math.log10(video.numberOfViews) >= 3;

      if (isMilestone && !isExisted) {
        const dataNotification = {
          sender: 'system',
          type: NOTIFICATION_TYPE.VIEW_VIDEO_MILESTONE,
          videoId: dto.videoId,
          videoTitle: video.title,
          viewVideoMilestone: +video.numberOfViews,
        };
        await this.notificationService.sendOneToOneNotification(receiver, dataNotification);
      }
    }
    return view;
  }

  async getTotalSecondByDate(time: Date, videoId: number) {
    return await this.viewRepository.getSecondWatchByTime(videoId, time);
  }
}
