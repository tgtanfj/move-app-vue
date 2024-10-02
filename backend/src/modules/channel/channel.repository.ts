import { Channel } from '@/entities/channel.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsRelations, Repository } from 'typeorm';

@Injectable()
export class ChannelRepository {
  constructor(@InjectRepository(Channel) private readonly channelRepository: Repository<Channel>) {}

  async getChannelByUserId(userId: number): Promise<Channel> {
    return await this.channelRepository.findOne({
      where: {
        user: { id: userId },
      },
    });
  }

  async findOne(
    channelId: number,
    relations: FindOptionsRelations<Channel> = {},
    withDeleted: boolean = false,
  ): Promise<Channel> {
    return await this.channelRepository.findOneOrFail({
      where: {
        id: channelId,
      },
      relations,
      withDeleted,
    });
  }
}
