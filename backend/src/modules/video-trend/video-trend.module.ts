import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VideoTrend } from '@/entities/video-trend.entity';
import { VideoService } from '../video/video.service';
import { VideoTrendService } from './video-trend.service';
import { VideoTrendRepository } from './video-trend.repository';

@Module({
  imports: [TypeOrmModule.forFeature([VideoTrend])],
  providers: [VideoTrendRepository, VideoTrendService],
  exports: [VideoTrendService],
})
export class VideoTrendModule {}
