import { WatchingVideoHistoryModule } from './../watching-video-history/watching-video-history.module';
import { Module } from '@nestjs/common';
import { VideoService } from './video.service';
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
import { CommentModule } from '../comment/comment.module';
import { ChannelModule } from '../channel/channel.module';
import { ThumbnailService } from '../thumbnail/thumbnail.service';
import { ThumbnailRepository } from '../thumbnail/thumbnail.repository';
import { ThumbnailModule } from '../thumbnail/thumbnail.module';
import { BullModule } from '@nestjs/bullmq';
import { UploadS3Processor } from '@/shared/queues/uploadS3.processor';

@Module({
  imports: [
    TypeOrmModule.forFeature([Video]),
    UserModule,
    CategoryModule,
    CommentModule,
    WatchingVideoHistoryModule,
    UserModule,
    ChannelModule,
    ThumbnailModule,
    BullModule.registerQueue({
      name: 'upload-s3',
      prefix: 'video',
    }),
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
})
export class VideoModule {}
