import { DurationType } from '@/entities/enums/durationType.enum';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { CategoryVideoDetailDto } from '@/modules/category/dto/response/category-video-detail.dto';
import { Expose } from 'class-transformer';

export class VideoDetail {
  @Expose()
  id: number;

  @Expose()
  title: string;

  @Expose()
  url: string;

  @Expose()
  thumbnail_url: string;

  @Expose()
  category: CategoryVideoDetailDto;

  @Expose()
  workoutLevel: WorkoutLevel;

  @Expose()
  duration: DurationType;

  @Expose()
  datePosted: string;

  @Expose()
  numberOfViews: number;

  @Expose()
  numberOfComments: number;

  @Expose()
  ratings: number;

  @Expose()
  canFollow: boolean | null;

  @Expose()
  urlS3:string
}
