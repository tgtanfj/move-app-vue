import { VideoTrend } from '@/entities/video-trend.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

export class VideoTrendRepository {
  constructor(@InjectRepository(VideoTrend) private readonly videoTrendRepository: Repository<VideoTrend>) {}
  async saveRecord(obj: any) {
    const newVideoTrend = this.videoTrendRepository.create({
      videoId: obj.id,
      title: obj.title,
      workoutLevel: obj.workoutLevel,
      createdAt: obj.createdAt,
      duration: obj.duration,
      videoLength: obj.videoLength,
      ratings: obj.ratings,
      numberOfViews: obj.numberOfView,
      categoryId: obj.category,
      channelId: obj.channelId,
    });
    return await this.videoTrendRepository.save(newVideoTrend);
  }

  async insert() {
    console.log('insert');
  }
}
