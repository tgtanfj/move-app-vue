import { Follow } from '@/entities/follow.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsRelations, Repository } from 'typeorm';

@Injectable()
export class FollowRepository {
  constructor(
    @InjectRepository(Follow)
    private readonly followRepository: Repository<Follow>,
  ) {}

  async checkFollowed(userId: number, channelId: number) {
    return this.followRepository.findOne({
      where: {
        channel: { id: channelId },
        user: { id: userId },
      },
    });
  }

  async countFollowers(channelId: number): Promise<number> {
    return this.followRepository.count({
      where: {
        channel: { id: channelId },
      },
    });
  }

  async getFollowingChannels(userId: number, limit: number, relations: FindOptionsRelations<Follow>) {
    return this.followRepository.find({
      where: {
        user: {
          id: userId,
        },
      },
      order: {
        channel: {
          isPinkBadge: 'ASC',
          isBlueBadge: 'ASC',
        },
      },
      take: limit,
      relations,
    });
  }
}
