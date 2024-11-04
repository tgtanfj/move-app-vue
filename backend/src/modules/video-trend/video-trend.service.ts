import { InjectRepository } from '@nestjs/typeorm';
import { VideoTrendRepository } from './video-trend.repository';
import { Repository } from 'typeorm';
import { VideoTrend } from '@/entities/video-trend.entity';

export class VideoTrendService {
  constructor(@InjectRepository(VideoTrend) private readonly videoTrendRepository: Repository<VideoTrend>) {}

  async createVideoTrend(obj: any) {
    const newVideoTrend = this.videoTrendRepository.create({
      videoId: obj.id,
      title: obj.title,
      workoutLevel: obj.workoutLevel,
      createdAt: obj.createdAt,
      duration: obj.duration,
      videoLength: obj.videoLength,
      ratings: obj.ratings,
      numberOfViews: obj.numberOfViews,
      categoryId: obj.category.id,
      channelId: obj.channel.id,
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
