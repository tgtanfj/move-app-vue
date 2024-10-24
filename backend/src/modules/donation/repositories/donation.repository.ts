import { Donation } from '@/entities/donation.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DonationDto } from '../dto/donation.dto';

@Injectable()
export class DonationRepository {
  constructor(
    @InjectRepository(Donation)
    private readonly donationRepository: Repository<Donation>,
  ) {}

  async donation(userId: number, donationDto: DonationDto): Promise<Donation> {
    const donationCreated = await this.donationRepository.create({
      video: {
        id: donationDto.videoId,
      },
      user: {
        id: userId,
      },
      giftPackage: {
        id: donationDto.giftPackageId,
      },
      content: donationDto.content,
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
