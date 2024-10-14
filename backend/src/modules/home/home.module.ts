import { Module } from '@nestjs/common';
import { HomeService } from './home.service';
import { HomeController } from './home.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '@/entities/user.entity';
import { Category } from '@/entities/category.entity';
import { WatchingVideoHistory } from '@/entities/watching-video-history.entity';
import { Video } from '@/entities/video.entity';
import { VideoTrendModule } from '../video-trend/video-trend.module';
import { VideoTrendService } from '../video-trend/video-trend.service';
import { VideoTrendRepository } from '../video-trend/video-trend.repository';
import { JwtAuthGuard } from '@/shared/guards';
import { UserModule } from '../user/user.module';
import { JwtService } from '@nestjs/jwt';
import { Channel } from '@/entities/channel.entity';
import { VideoTrend } from '@/entities/video-trend.entity';
import { VideoModule } from '../video/video.module';
import { VimeoService } from '@/shared/services/vimeo.service';
import { ThumbnailModule } from '../thumbnail/thumbnail.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, Category, WatchingVideoHistory, Video, Channel, VideoTrend, VideoModule]),
    VideoTrendModule,
    UserModule,
    VideoModule,
    ThumbnailModule,
  ],
  controllers: [HomeController],
  providers: [HomeService, JwtService, VimeoService],
})
export class HomeModule {}
