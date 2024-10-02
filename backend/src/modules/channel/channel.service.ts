import { BadRequestException, Injectable } from '@nestjs/common';
import { ChannelRepository } from './channel.repository';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Channel } from '@/entities/channel.entity';

@Injectable()
export class ChannelService {
  constructor(private readonly channelRepository: ChannelRepository) {}

  async getChannelByUserId(userId: number): Promise<Channel> {
    return await this.channelRepository.getChannelByUserId(userId).catch((error) => {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_FOUND_ANY_CHANNEL_OF_THIS_USER);
    });
  }

  async findOne(channelId: number) {
    return await this.channelRepository.findOne(channelId).catch((error) => {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_FOUND_ANY_CHANNEL);
    });
  }
}
