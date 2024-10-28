import { Channel } from '@/entities/channel.entity';
import { Donation } from '@/entities/donation.entity';
import { Payment } from '@/entities/payment.entity';
import { User } from '@/entities/user.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

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
}
