import { VideoTrend } from '@/entities/video-trend.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

export class VideoTrendRepository {
  constructor(@InjectRepository(VideoTrend) private readonly videoTrendRepository: Repository<VideoTrend>) {}
  async saveRecord(obj: any) {
    const newVideoTrend = this.videoTrendRepository.create({
      videoId: obj.videoId,
      title: obj.title,
      workoutLevel: obj.workoutLevel,
      thumbnailURL: obj.thumbnailURL,
      numberOfViews: obj.numberOfViews,
      videoLength: obj.videoLength,
      ratings: obj.ratings,
      category: obj.category,
      createdAt: obj.createdAt ? new Date(obj.createdAt) : null, // Convert createdAt if present
      duration: obj.duration,
      channelName: obj.channelName,
      channelImage: obj.channelImage,
      isBlueBadge: obj.isBlueBadge,
      isPinkBadge: obj.isPinkBadge,
    });
    return await this.videoTrendRepository.save(newVideoTrend);
  }

  async insert() {
    console.log('insert');
  }
}
