import { DurationType } from '@/entities/enums/durationType.enum';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
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
  category: string;

  @Expose()
  createdAt: Date;

  @Expose()
  workoutLevel: WorkoutLevel;

  @Expose()
  duration: DurationType;
}

export class ChannelItem {
  @Expose()
  name: string;

  @Expose()
  image: string;

  @Expose()
  isBlueBadge: boolean;

  @Expose()
  isPinkBadge: boolean;
}
