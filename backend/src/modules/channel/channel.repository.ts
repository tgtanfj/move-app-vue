import { Channel } from '@/entities/channel.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsRelations, Repository, UpdateResult } from 'typeorm';

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

  async searchChannels(keyword: string): Promise<Channel[]> {
    return this.channelRepository
      .createQueryBuilder('channel')
      .where('channel.name ILIKE :keyword', { keyword: `%${keyword}%` })
      .getMany();
  }

  async updateChannel(channel: Channel) {
    return await this.channelRepository.save(channel);
  }

  async getUserByChannel(channelId: number) {
    const user = await this.channelRepository
      .createQueryBuilder('ch')
      .leftJoinAndSelect('ch.user', 'u')
      .where('ch.id = :channelId', { channelId })
      .select(['u.id', 'u.username', 'u.email', 'u.fullName', 'u.city', 'u.avatar'])
      .getOne();
    return user;
  }

  async updateREPs(channelId: number, numberOfREPs: number): Promise<UpdateResult> {
    return await this.channelRepository.update(channelId, {
      numberOfREPs,
    });
  }

  async createChannel(userId: number, dto: object) {
    const channelExist = await this.channelRepository.findOne({
      where: { user: { id: userId } },
    });

    if (channelExist) return channelExist.id;
    const newChannel = this.channelRepository.create({ ...dto, user: { id: userId } });
    return (await this.channelRepository.save(newChannel)).id;
  }

  async editChannel(channelId: number, dto: Partial<Channel>) {
    return await this.channelRepository.update(channelId, dto);
  }

  async updateEmailPayPal(channelId: number, emailPayPal: string): Promise<UpdateResult> {
    return await this.channelRepository.update(channelId, {
      emailPayPal,
    });
  }
  async getAllComments(userId: number) {
    return await this.channelRepository
      .createQueryBuilder('channel')
      .leftJoinAndSelect('channel.comments', 'comment')
      .where('channel.user = :userId', { userId })
      .getMany();
  }
}
