import { Donation } from '@/entities/donation.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class DonationRepository {
  constructor(
    @InjectRepository(Donation)
    private readonly donationRepository: Repository<Donation>,
  ) {}

  async donation(userId: number, videoId: number, giftPackageId: number): Promise<Donation> {
    const donationCreated = await this.donationRepository.create({
      video: {
        id: videoId,
      },
      user: {
        id: userId,
      },
      giftPackage: {
        id: giftPackageId,
      },
    });

    return await this.donationRepository.save(donationCreated);
  }
}
