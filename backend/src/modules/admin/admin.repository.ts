import { Channel } from '@/entities/channel.entity';
import { Donation } from '@/entities/donation.entity';
import { DurationType } from '@/entities/enums/durationType.enum';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { Payment } from '@/entities/payment.entity';
import { User } from '@/entities/user.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Repository } from 'typeorm';
import { SortVideoAdmin } from './dto/request/sort-video-admin.dto';
import { PaginationDto } from '../video/dto/request/pagination.dto';
import { Video } from '@/entities/video.entity';

@Injectable()
export class AdminRepository {
  constructor(
    @InjectRepository(Payment)
    private readonly paymentRepository: Repository<Payment>,
    @InjectRepository(Donation)
    private readonly donationRepository: Repository<Donation>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Channel)
    private readonly channelRepository: Repository<Channel>,
    @InjectRepository(Video)
    private readonly videoRepository: Repository<Video>,
  ) {}

  async getUsers() {
    return await this.userRepository.find();
  }

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

  async getVideoAdmin(
    query: string,
    workoutLevel: WorkoutLevel,
    duration: DurationType,
    sortBy: SortVideoAdmin,
    paginationDto: PaginationDto,
  ) {
    const data = await this.videoRepository.find({
      where: {
        workoutLevel,
        duration,
        thumbnails: {
          selected: true,
        },
        title: query ? ILike(`%${query}%`) : undefined,
      },
      order: {
        title: sortBy?.includes('title') ? (sortBy === SortVideoAdmin.TITLE_ASC ? 'ASC' : 'DESC') : undefined,
        numberOfViews: sortBy?.includes('views')
          ? sortBy === SortVideoAdmin.VIEWS_ASC
            ? 'ASC'
            : 'DESC'
          : undefined,
        numberOfComments: sortBy?.includes('comment')
          ? sortBy === SortVideoAdmin.COMMENT_ASC
            ? 'ASC'
            : 'DESC'
          : undefined,
        ratings: sortBy?.includes('ratings')
          ? sortBy === SortVideoAdmin.RATINGS_ASC
            ? 'ASC'
            : 'DESC'
          : undefined,
      },
      take: paginationDto.take,
      skip: PaginationDto.getSkip(paginationDto.take, paginationDto.page),
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
        views: true,
      },
    });
    return data;
  }
}
