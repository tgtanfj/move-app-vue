import { Category } from '@/entities/category.entity';
import { Video } from '@/entities/video.entity';
import { WatchingVideoHistory } from '@/entities/watching-video-history.entity';
import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '@/entities/user.entity';
import { getField } from '../../shared/utils/get-field.util';
import { map } from 'lodash';
import { ChannelItem, VideoItemDto } from './dto/video-item.dto';
import { Cron } from '@nestjs/schedule';
import { VideoTrendService } from '../video-trend/video-trend.service';
import { ApiConfigService } from '@/shared/services/api-config.service';

@Injectable()
export class HomeService {
  constructor(
    @InjectRepository(Video) private videoRepository: Repository<Video>,
    @InjectRepository(Category) private cateRepository: Repository<Category>,
    @InjectRepository(WatchingVideoHistory) private watchingRepository: Repository<WatchingVideoHistory>,
    @InjectRepository(User) private userRepository: Repository<User>,
    private apiConfig: ApiConfigService,
    private videoTrendService: VideoTrendService,
  ) {}

  // @Cron('* 1 0 * *')
  // @Cron('* 30 * * * *')
  async createListVideoHotTrend() {
    // clear video hot trend
    await this.videoTrendService.deleteAll();
    //The video was posted 14 days ago
    const numberDayValid = this.apiConfig.getNumber('NUMBER_DAY_VALID');
    const postedDateValid = new Date();
    postedDateValid.setDate(postedDateValid.getDate() - numberDayValid);

    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const formattedYesterday = yesterday.toISOString().split('T')[0];

    const result = await this.videoRepository
      .createQueryBuilder('video')
      .limit(10)
      .leftJoinAndSelect('video.views', 'views')
      .innerJoinAndSelect('video.channel', 'channel')
      .innerJoinAndSelect('video.category', 'category')
      .innerJoinAndSelect('video.thumbnails', 'thumbnails')
      .where('video.createdAt <= :postedDateValid', { postedDateValid: postedDateValid })
      .andWhere('views.viewDate = :yesterday', { yesterday: formattedYesterday })
      .andWhere('video.ratings >= 4')
      .andWhere('video.numberOfViews >= 1000')
      .orderBy('video.numberOfViews', 'DESC')
      .select([
        'video.id',
        'video.title',
        'video.workoutLevel',
        'video.duration',
        'video.ratings',
        'video.numberOfViews as number_of_views',
        'channel.name AS channel_name',
        'channel.image as channel_avt',
        'channel.isBlueBadge as is_blue_badge',
        'channel.isPinkBadge as is_pink_badge',
        'category.title as category_name',
      ])
      .addSelect('thumbnails')
      .getRawMany();

    const banners = [];
    result.forEach(async (obj) => {
      const item = this.convertToVideoItemDto(obj);
      banners.push(item);
      await this.videoTrendService.createVideoTrend(item);
    });
    return banners;
  }

  async getListVideoTrend() {
    const result = await this.videoTrendService.getAll();
    if (!result) {
      throw new BadRequestException();
    }
    return result;
  }

  convertToVideoItemDto(rawData: any): VideoItemDto {
    const videoItem = new VideoItemDto();
    videoItem.id = rawData.video_id;
    videoItem.thumbnailURL = rawData.thumbnails_image;
    videoItem.numberOfViews = rawData.number_of_views || null;
    videoItem.videoLength = rawData.video_duration || null;
    videoItem.title = rawData.video_title;
    videoItem.ratings = rawData.video_ratings;
    videoItem.createdAt = new Date(rawData.video_createdAt);
    videoItem.workoutLevel = rawData.video_workoutLevel;
    videoItem.duration = rawData.video_duration;

    videoItem.channel = new ChannelItem();
    videoItem.channel.name = rawData.channel_name;
    videoItem.channel.image = rawData.channel_avt;
    videoItem.channel.isBlueBadge = rawData.is_blue_badge;
    videoItem.channel.isPinkBadge = rawData.is_pink_badge;

    videoItem.category = rawData.category_name;

    return videoItem;
  }
}
