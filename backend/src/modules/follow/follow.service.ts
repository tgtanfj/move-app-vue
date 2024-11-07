import { BadRequestException, forwardRef, Inject, Injectable } from '@nestjs/common';
import { FollowRepository } from './follow.repository';
import { Follow } from '@/entities/follow.entity';
import { FindOptionsRelations } from 'typeorm';
import { ChannelService } from '../channel/channel.service';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { UserInfoDto } from '../user/dto/user-info.dto';
import { NotificationService } from '../notification/notification.service';
import { db } from '@/shared/firebase/firebase.config';

@Injectable()
export class FollowService {
  constructor(
    private readonly followRepository: FollowRepository,
    @Inject(forwardRef(() => ChannelService))
    private readonly channelService: ChannelService,
    private readonly notificationService: NotificationService,
  ) {}

  async isFollowed(userId: number, channelId: number) {
    return (await this.followRepository.checkFollowed(userId, channelId)) ? true : false;
  }

  async getNumberOfFollowers(channelId: number): Promise<number> {
    return await this.followRepository.countFollowers(channelId);
  }

  async getFollowingChannels(userId: number, relations: FindOptionsRelations<Follow>): Promise<Follow[]> {
    return await this.followRepository.getFollowingChannels(userId, relations);
  }

  async save(userInfo: UserInfoDto, channelId: number) {
    const userId = userInfo.id;
    const ins = await this.followRepository.findOneFollow(userId, channelId);
    if (ins) {
      throw new BadRequestException();
    }

    const result = await this.followRepository.save(userId, channelId);
    if (!result) {
      throw new BadRequestException();
    }

    await this.channelService.increaseFollow(channelId);
    await this.sendNotificationFollow(userInfo, channelId);

    return result;
  }

  async unfollow(userId: number, channelId: number) {
    const ins = await this.findOneOrThrow(userId, channelId);
    const unFollow = await this.followRepository.delete(ins);
    if (!unFollow) {
      throw new BadRequestException();
    }
    await this.channelService.decreaseFollow(channelId);

    await this.removeNotificationFollow(channelId, userId);
    return unFollow;
  }

  async findOneOrThrow(userId: number, channelId: number) {
    const ins = await this.followRepository.findOneFollow(userId, channelId);
    if (!ins) {
      throw new BadRequestException();
    }
    return ins;
  }

  async removeNotificationFollow(channelId: number, userId: number) {
    const channel = await this.channelService.findOne(channelId, { user: true });
    const receiveId = channel.user?.id;
    const remove = [];

    const notificationsRef = db.ref(`notifications/${receiveId}`);
    const snapshot = await notificationsRef.get();
    snapshot.forEach((childSnapshot) => {
      const value = childSnapshot.val().data;
      const isRead = childSnapshot.val().isRead;
      const senderId = value?.sender?.id;
      if (value?.type === NOTIFICATION_TYPE.FOLLOW && senderId === +userId) {
        if (isRead === false) {
          remove.push(childSnapshot.ref.remove());
        } else {
          childSnapshot.ref.update({ hasDelete: true });
        }
      }
    });

    await Promise.all(remove);
  }

  async sendNotificationFollow(userInfo: UserInfoDto, channelId: number) {
    const channel = await this.channelService.findOne(channelId, { user: true });
    const receiver = channel.user.id;

    const dataNotification = {
      sender: userInfo,
      type: NOTIFICATION_TYPE.FOLLOW,
    };
    await this.notificationService.sendOneToOneNotification(receiver, dataNotification);

    const isExisted = await this.notificationService.checkNotificationExistsAntiSpam(
      receiver,
      +channel.numberOfFollowers,
    );

    const isMilestone =
      Number.isInteger(Math.log10(channel.numberOfFollowers)) && Math.log10(channel.numberOfFollowers) >= 2;

    if (channel.numberOfFollowers > 0 && isMilestone && !isExisted) {
      const dataNotification = {
        sender: 'system',
        type: NOTIFICATION_TYPE.FOLLOW_MILESTONE,
        followMilestone: +channel.numberOfFollowers,
      };
      await this.notificationService.sendOneToOneNotification(receiver, dataNotification);
    }
  }
}
