import { BadRequestException, Injectable } from '@nestjs/common';
import { ChannelService } from '../channel/channel.service';
import { VideoService } from '../video/video.service';
import { DonationDto } from './dto/donation.dto';
import { DonationRepository } from './repositories/donation.repository';
import { GiftPackageRepository } from './repositories/gift-package.repository';

@Injectable()
export class DonationService {
  constructor(
    private readonly giftPackageRepository: GiftPackageRepository,
    private readonly donationRepository: DonationRepository,
    private readonly channelService: ChannelService,
    private readonly videoService: VideoService,
  ) {}

  async getGiftPackages() {
    return this.giftPackageRepository.getGiftPackages();
  }

  async donation(userId: number, donationDto: DonationDto) {
    try {
      const { videoId, giftPackageId } = donationDto;

      await this.donationRepository.donation(userId, videoId, giftPackageId);

      const giftPackage = await this.giftPackageRepository.findOneGiftPackage(giftPackageId);

      const { channel } = await this.videoService.findChannel(videoId);

      const channelREPs: number = +channel.numberOfREPs + +giftPackage.numberOfREPs;

      this.channelService.updateREPs(channel.id, channelREPs);
    } catch (error) {
      throw new BadRequestException(error);
    }
  }
}
