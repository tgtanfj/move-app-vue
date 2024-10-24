import { VideoService } from '@/modules/video/video.service';
import { forwardRef, Module } from '@nestjs/common';
import { VideoController } from './video.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Video } from '@/entities/video.entity';
import { VideoRepository } from './video.repository';
import { AwsS3Service } from '@/shared/services/aws-s3.service';
import { GeneratorService } from '@/shared/services/generator.service';
import { CategoryModule } from '../category/category.module';
import { CategoryService } from '../category/category.service';
import { VimeoService } from '@/shared/services/vimeo.service';
import { UserModule } from '../user/user.module';
import { JwtService } from '@nestjs/jwt';
import { ChannelModule } from '../channel/channel.module';
import { ThumbnailModule } from '../thumbnail/thumbnail.module';
import { BullModule } from '@nestjs/bullmq';
import { UploadS3Processor } from '@/shared/queues/uploadS3.processor';
import { WatchingVideoHistoryModule } from '../watching-video-history/watching-video-history.module';
import { Follow } from '@/entities/follow.entity';
import { ViewModule } from '../view/view.module';
import { DonationModule } from '../donation/donation.module';
import { NotificationModule } from '../notification/notification.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Video, Follow]),
    CategoryModule,
    WatchingVideoHistoryModule,
    forwardRef(() => UserModule),
    forwardRef(() => ChannelModule),
    forwardRef(() => WatchingVideoHistoryModule),
    ThumbnailModule,
    BullModule.registerQueueAsync({
      name: 'upload-s3',
    }),
    ViewModule,
    forwardRef(() => DonationModule),
    NotificationModule,
    // DonationModule
  ],
  controllers: [VideoController],
  providers: [
    VideoService,
    VideoRepository,
    JwtService,
    AwsS3Service,
    GeneratorService,
    CategoryService,
    VimeoService,
    UploadS3Processor,
  ],
  exports: [VideoService, VideoRepository, BullModule],
})
export class VideoModule {}
