import { Donation } from '@/entities/donation.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { MoreThanOrEqual, Repository } from 'typeorm';

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
  async getTotalDonationOfVideo(time: Date, videoId: number) {
    // const sum = await this.donationRepository.sum('giftPackage.numberOfREPS', {
    //   createdAt: MoreThanOrEqual(time),
    //   video: {
    //     id: videoId,
    //   },
    //   giftPackage: {},
    // });
    const result = await this.donationRepository
      .createQueryBuilder('donation')
      .select('donation.videoId', 'videoId')
      .addSelect('SUM(giftPackage.numberOfREPs)', 'totalREPs')
      .leftJoin('gift-packages', 'giftPackage', 'giftPackage.id = donation.giftPackageId')
      .where('donation.videoId = :videoId', { videoId })
      .groupBy('donation.videoId')
      .getRawOne(); // Trả về kết quả tổng hợp

    return result;
  }
}
