import { BadRequestException, Injectable } from '@nestjs/common';
import { ChannelService } from '../channel/channel.service';
import { VideoService } from '../video/video.service';
import { DonationDto } from './dto/donation.dto';
import { DonationRepository } from './repositories/donation.repository';
import { GiftPackageRepository } from './repositories/gift-package.repository';
import { NotificationService } from '../notification/notification.service';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { UserInfoDto } from '../user/dto/user-info.dto';

@Injectable()
export class DonationService {
  constructor(
    private readonly giftPackageRepository: GiftPackageRepository,
    private readonly donationRepository: DonationRepository,
    private readonly channelService: ChannelService,
    private readonly videoService: VideoService,
    private readonly notificationService: NotificationService,
  ) {}

  async getGiftPackages() {
    return this.giftPackageRepository.getGiftPackages();
  }

  async donation(userInfo: UserInfoDto, donationDto: DonationDto) {
    try {
      const userId = userInfo.id;
      const { videoId, giftPackageId } = donationDto;

      await this.donationRepository.donation(userId, donationDto);

      const giftPackage = await this.giftPackageRepository.findOneGiftPackage(giftPackageId);

      const { channel, title } = await this.videoService.findChannel(videoId);

      const channelREPs: number = +channel.numberOfREPs + +giftPackage.numberOfREPs;
      const totalREPs: number = +channel.totalREPs + +giftPackage.numberOfREPs;
      await this.channelService.editChannel(channel.id, { totalREPs });

      this.channelService.updateREPs(channel.id, channelREPs);

      const receiver = await this.channelService.findOne(channel.id, { user: true });

      const dataNotification = {
        sender: userInfo,
        type: NOTIFICATION_TYPE.DONATION,
        videoId: videoId,
        videoTitle: title,
        donation: +giftPackage.numberOfREPs,
      };
      await this.notificationService.sendOneToOneNotification(receiver.user.id, dataNotification);

      const aroundTotalREPs = Math.pow(10, Math.floor(Math.log10(totalREPs)));

      const isExisted = await this.notificationService.checkNotificationExistsAntiSpam(
        receiver.user.id,
        userInfo.id,
        aroundTotalREPs,
      );

      if (!isExisted) {
        const dataNotification = {
          sender: 'system',
          type: NOTIFICATION_TYPE.REP_MILESTONE,
          rep_milestone: aroundTotalREPs,
        };
        await this.notificationService.sendOneToOneNotification(receiver.user.id, dataNotification);
      }
    } catch (error) {
      throw new BadRequestException(error);
    }
  }
}
