import { Channel } from '@/entities/channel.entity';
import { Donation } from '@/entities/donation.entity';
import { Payment } from '@/entities/payment.entity';
import { User } from '@/entities/user.entity';
import { Video } from '@/entities/video.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsOrder, ILike, Repository } from 'typeorm';
import UserQueryDto from './dto/request/user-query.dto';
import VideoAdminQueryDto from './dto/request/video-admin-query.dto';
import UserRepository from './repositories/user.repository';

@Injectable()
export class AdminRepository {
  constructor(
    @InjectRepository(Payment)
    private readonly paymentRepository: Repository<Payment>,
    @InjectRepository(Donation)
    private readonly donationRepository: Repository<Donation>,

    private readonly userRepository: UserRepository,
    @InjectRepository(Channel)
    private readonly channelRepository: Repository<Channel>,
    @InjectRepository(Video)
    private readonly videoRepository: Repository<Video>,
  ) {}

  async getChannels() {
    return await this.channelRepository.find();
  }

  async getPayments() {
    return await this.paymentRepository.find();
  }

  async getChannelByUserId(id: number) {
    return await this.channelRepository.findOne({
      where: {
        user: {
          id,
        },
      },
    });
  }

  async getSumTopUp(userId: number): Promise<number> {
    const payments = await this.paymentRepository.find({
      where: {
        user: { id: userId },
      },
      relations: {
        repsPackage: true,
      },
    });

    return payments.reduce((sum, payment) => {
      const reps = payment.repsPackage?.numberOfREPs || 0;
      return sum + reps;
    }, 0);
  }

  async getSumDonation(userId: number): Promise<number> {
    const channel = await this.channelRepository.findOne({
      where: { user: { id: userId } },
    });

    if (!channel) return 0;

    const donations = await this.donationRepository.find({
      where: {
        video: { channel: { id: channel.id } },
      },
      relations: {
        giftPackage: true,
      },
    });

    return donations.reduce((sum, donation) => {
      const reps = donation.giftPackage?.numberOfREPs || 0;
      return sum + reps;
    }, 0);
  }

  async getVideoAdmin(dto: VideoAdminQueryDto) {
    const { query, workoutLevel, duration, sortBy, sortType, take, page } = dto;

    let order: FindOptionsOrder<Video> = { createdAt: 'desc' };

    if (sortBy) {
      order = {
        [sortBy]: sortType,
        ...order,
      };

      if (sortBy === 'createdAt') {
        order = {
          createdAt: sortType,
        };
      }
    }

    const skip = (page - 1) * take;

    const data = await this.videoRepository.findAndCount({
      where: {
        workoutLevel,
        duration,
        thumbnails: {
          selected: true,
        },
        title: query ? ILike(`%${query}%`) : undefined,
      },
      order: order,
      take: take,
      skip: skip,
      relations: { thumbnails: true },
      select: {
        id: true,
        title: true,
        workoutLevel: true,
        duration: true,
        numberOfViews: true,
        ratings: true,
        numberOfComments: true,
        thumbnails: {
          id: true,
          image: true,
          selected: true,
        },
        createdAt: true,
      },
    });
    return data;
  }

  async filterUsers(userQueryDto: UserQueryDto): Promise<[User[], number]> {
    return this.userRepository.filterUsers(userQueryDto);
  }
}
