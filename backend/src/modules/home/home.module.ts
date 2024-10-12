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

@Module({
  imports: [TypeOrmModule.forFeature([User, Category, WatchingVideoHistory, Video]), VideoTrendModule],
  controllers: [HomeController],
  providers: [HomeService],
})
export class HomeModule {}
