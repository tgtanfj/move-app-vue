import { WatchingVideoHistoryModule } from './../watching-video-history/watching-video-history.module';
import { Module } from '@nestjs/common';
import { VideoService } from './video.service';
import { VideoController } from './video.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Video } from '@/entities/video.entity';
import { VideoRepository } from './video.repository';
import { CommentModule } from '../comment/comment.module';
import { UserModule } from '../user/user.module';
import { ChannelModule } from '../channel/channel.module';
import { JwtService } from '@nestjs/jwt';

@Module({
  imports: [
    TypeOrmModule.forFeature([Video]),
    CommentModule,
    WatchingVideoHistoryModule,
    UserModule,
    ChannelModule,
  ],
  controllers: [VideoController],
  providers: [VideoService, VideoRepository, JwtService],
})
export class VideoModule {}
