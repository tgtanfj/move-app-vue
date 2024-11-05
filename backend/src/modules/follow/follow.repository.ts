import { Follow } from '@/entities/follow.entity';
import { BadRequestException, Injectable } from '@nestjs/common';
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

  async getFollowingChannels(userId: number, relations: FindOptionsRelations<Follow>) {
    return this.followRepository.find({
      where: {
        user: {
          id: userId,
        },
      },
      order: {
        channel: {
          numberOfFollowers: 'DESC',
          isBlueBadge: 'DESC',
        },
      },
      relations,
    });
  }
  async save(userId: number, channelId: number) {
    const newIns = this.followRepository.create({
      user: {
        id: userId,
      },
      channel: {
        id: channelId,
      },
    });
    return await this.followRepository.save(newIns);
  }

  async delete(follow: Follow) {
    return await this.followRepository.delete(follow.id);
  }

  async findOneFollow(userId: number, channelId: number) {
    return await this.followRepository.findOne({
      where: {
        user: {
          id: userId,
        },
        channel: {
          id: channelId,
        },
      },
    });
  }
}
