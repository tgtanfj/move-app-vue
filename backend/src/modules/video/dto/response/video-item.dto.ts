import { DurationType } from '@/entities/enums/durationType.enum';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { CategoryVideoDetailDto } from '@/modules/category/dto/response/category-video-detail.dto';
import { Expose } from 'class-transformer';

export class VideoItemDto {
  @Expose()
  id: number;

  @Expose()
  thumbnailURL: string;

  @Expose()
  numberOfViews: number;

  @Expose()
  videoLength: number;

  @Expose()
  title: string;

  @Expose()
  ratings: number;

  channel: ChannelItem;

  @Expose()
  category: CategoryVideoDetailDto;

  @Expose()
  createdAt: Date;

  @Expose()
  workoutLevel: WorkoutLevel;

  @Expose()
  duration: DurationType;
}

class ChannelItem {
  @Expose()
  name: string;

  @Expose()
  image: string;

  @Expose()
  isBlueBadge: boolean;

  @Expose()
  isPinkBadge: boolean;
}
