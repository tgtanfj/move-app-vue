import { BadRequestException, forwardRef, Inject, Injectable } from '@nestjs/common';
import { FollowRepository } from './follow.repository';
import { Follow } from '@/entities/follow.entity';
import { FindOptionsRelations } from 'typeorm';
import { ChannelService } from '../channel/channel.service';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { UserInfoDto } from '../user/dto/user-info.dto';
import { NotificationService } from '../notification/notification.service';

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

  async getFollowingChannels(
    userId: number,
    limit: number,
    relations: FindOptionsRelations<Follow>,
  ): Promise<Follow[]> {
    return await this.followRepository.getFollowingChannels(userId, limit, relations);
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
    const receiver = (await this.channelService.findOne(channelId, { user: true })).user.id;

    const isExisted = await this.notificationService.checkNotificationExistsAntiSpam(receiver, userInfo.id);
    if (!isExisted) {
      const dataNotification = {
        sender: userInfo,
        type: NOTIFICATION_TYPE.FOLLOW,
      };
      await this.notificationService.sendOneToOneNotification(receiver, dataNotification);
    }

    return result;
  }

  async unfollow(userId: number, channelId: number) {
    const ins = await this.findOneOrThrow(userId, channelId);
    const unFollow = await this.followRepository.delete(ins);
    if (!unFollow) {
      throw new BadRequestException();
    }
    await this.channelService.decreaseFollow(channelId);
    return unFollow;
  }

  async findOneOrThrow(userId: number, channelId: number) {
    const ins = await this.followRepository.findOneFollow(userId, channelId);
    if (!ins) {
      throw new BadRequestException();
    }
    return ins;
  }
}
