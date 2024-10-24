import { Expose } from 'class-transformer';

export class OverviewVideoResponseDto {
  @Expose()
  title: string;

  @Expose()
  category: string;

  @Expose()
  rating: number;

  @Expose()
  thumbnail: string;

  @Expose()
  numberOfViews: number;

  @Expose()
  numberOfReps: number;
}
