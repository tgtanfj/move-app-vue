import { Channel } from '@/entities/channel.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

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
}
