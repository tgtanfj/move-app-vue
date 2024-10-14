import { BadRequestException, Injectable } from '@nestjs/common';
import { FollowRepository } from './follow.repository';
import { Follow } from '@/entities/follow.entity';
import { FindOptionsRelations } from 'typeorm';

@Injectable()
export class FollowService {
  constructor(private readonly followRepository: FollowRepository) {}

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

  async save(userId: number, channelId: number) {
    const ins = await this.followRepository.findOneFollow(userId, channelId);
    if (ins) {
      throw new BadRequestException();
    }
    const result = await this.followRepository.save(userId, channelId);
    if (!result) {
      throw new BadRequestException();
    }
    return result;
  }

  async unfollow(userId: number, channelId: number) {
    const ins = await this.findOneOrThrow(userId, channelId);
    const unFollow = await this.followRepository.delete(ins);
    if (!unFollow) {
      throw new BadRequestException();
    }
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
