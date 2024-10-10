import { InjectRepository } from '@nestjs/typeorm';
import { VideoTrendRepository } from './video-trend.repository';
import { VideoTrend } from '@/entities/video-trend.entity';
import { Repository } from 'typeorm';

export class VideoTrendService {
  constructor(@InjectRepository(VideoTrend) private readonly videoTrendRepository: Repository<VideoTrend>) {}

  async createVideoTrend(obj: any) {
    const newVideoTrend = this.videoTrendRepository.create({
      videoId: obj.id,
      title: obj.title,
      workoutLevel: obj.workoutLevel,
      thumbnailURL: obj.thumbnailURL,
      numberOfViews: obj.numberOfViews,
      videoLength: obj.videoLength,
      ratings: obj.ratings,
      category: obj.category,
      duration: obj.duration,
      channelName: obj.channel.name,
      channelImage: obj.channel.name,
      isBlueBadge: obj.channel.isBlueBadge,
      isPinkBadge: obj.channel.isPinkBadge,
    });
    return await this.videoTrendRepository.save(newVideoTrend);
  }
  async deleteAll() {
    await this.videoTrendRepository.clear();
  }
  async getAll() {
    return await this.videoTrendRepository.find();
  }
}
