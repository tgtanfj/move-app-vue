import { User } from '@/entities/user.entity';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { BadRequestException, Injectable } from '@nestjs/common';
import { I18nService } from 'nestjs-i18n';
import { ChannelService } from '../channel/channel.service';
import { NotificationService } from '../notification/notification.service';
import { UserService } from '../user/user.service';
import { VideoService } from '../video/video.service';
import { DonationDto } from './dto/donation.dto';
import { DonationRepository } from './repositories/donation.repository';
import { GiftPackageRepository } from './repositories/gift-package.repository';

@Injectable()
export class DonationService {
  constructor(
    private readonly giftPackageRepository: GiftPackageRepository,
    private readonly donationRepository: DonationRepository,
    private readonly channelService: ChannelService,
    private readonly videoService: VideoService,
    private readonly notificationService: NotificationService,
    private readonly userService: UserService,
    private readonly i18n: I18nService,
  ) {}

  async getGiftPackages() {
    return this.giftPackageRepository.getGiftPackages();
  }

  async donation(userInfo: User, donationDto: DonationDto) {
    try {
      const userId = userInfo.id;
      const { videoId, giftPackageId } = donationDto;

      const giftPackage = await this.giftPackageRepository.findOneGiftPackage(giftPackageId);

      if (userInfo.numberOfREPs < giftPackage.numberOfREPs) {
        throw new BadRequestException(this.i18n.t('exceptions.payment.NOT_ENOUGH_REPS'));
      }
      const { channel, title } = await this.videoService.findChannel(videoId);

      const channelREPs: number = +channel.numberOfREPs + +giftPackage.numberOfREPs;
      const totalREPs: number = +channel.totalREPs + +giftPackage.numberOfREPs;
      const userREPs: number = userInfo.numberOfREPs - giftPackage.numberOfREPs;

      await this.donationRepository.donation(userId, donationDto);

      await this.channelService.editChannel(channel.id, { totalREPs });

      this.channelService.updateREPs(channel.id, channelREPs);

      this.userService.updateREPs(userId, userREPs);

      const receiver = await this.channelService.findOne(channel.id, { user: true });

      const sender = {
        id: userId,
        username: userInfo.username,
        avatar: userInfo.avatar,
      };
      const dataNotification = {
        sender: sender,
        type: NOTIFICATION_TYPE.DONATION,
        videoId: videoId,
        videoTitle: title,
        donation: +giftPackage.numberOfREPs,
      };
      await this.notificationService.sendOneToOneNotification(receiver.user.id, dataNotification);

      const aroundTotalREPs = Math.pow(10, Math.floor(Math.log10(totalREPs)));

      const isExisted = await this.notificationService.checkNotificationExistsAntiSpam(
        receiver.user.id,
        aroundTotalREPs,
      );

      if (!isExisted) {
        const dataNotification = {
          sender: 'system',
          type: NOTIFICATION_TYPE.REP_MILESTONE,
          repMilestone: aroundTotalREPs,
        };
        await this.notificationService.sendOneToOneNotification(receiver.user.id, dataNotification);
      }
    } catch (error) {
      throw new BadRequestException(error);
    }
  }
}
