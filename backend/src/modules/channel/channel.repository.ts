import { Channel } from '@/entities/channel.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class ChannelRepository {
  constructor(@InjectRepository(Channel) private readonly channelRepository: Repository<Channel>) {}

  async getChannelByUserId(userId: number): Promise<Channel> {
    return await this.channelRepository
      .findOne({
        where: {
          user: { id: userId },
        },
      })
      .then(async (foundChannel) => {
        if (!foundChannel) throw new Error(ERRORS_DICTIONARY.NOT_FOUND_ANY_CHANNEL_OF_THIS_USER);

        return foundChannel;
      })
      .catch((error) => {
        throw error;
      });
  }
}
