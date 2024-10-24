import { DurationType } from '@/entities/enums/durationType.enum';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { CategoryVideoDetailDto } from '@/modules/category/dto/response/category-video-detail.dto';
import { ChannelItemDto } from '@/modules/channel/dto/response/channel-item.dto';
import { Expose, Transform, Type } from 'class-transformer';

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
  @Transform(({ value }) => {
    return parseFloat(value.toFixed(1));
  })
  ratings: number;

  channel: ChannelItemDto;

  @Expose()
  category: CategoryVideoDetailDto;

  @Expose()
  createdAt: Date;

  @Expose()
  workoutLevel: WorkoutLevel;

  @Expose()
  duration: DurationType;
}
