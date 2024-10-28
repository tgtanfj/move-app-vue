import { Donation } from '@/entities/donation.entity';
import { GiftPackage } from '@/entities/gift-package.entity';
import { Module, forwardRef } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChannelModule } from '../channel/channel.module';
import { UserModule } from '../user/user.module';
import { VideoModule } from '../video/video.module';
import { DonationController } from './donation.controller';
import { DonationService } from './donation.service';
import { DonationRepository } from './repositories/donation.repository';
import { GiftPackageRepository } from './repositories/gift-package.repository';
import { NotificationModule } from '../notification/notification.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([GiftPackage, Donation]),
    forwardRef(() => UserModule),
    forwardRef(() => ChannelModule),
    forwardRef(() => VideoModule),
    NotificationModule,
  ],
  controllers: [DonationController],
  providers: [DonationService, DonationRepository, GiftPackageRepository, JwtService],
  exports: [DonationService, DonationRepository, GiftPackageRepository],
})
export class DonationModule {}
