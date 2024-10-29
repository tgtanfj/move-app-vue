import { Expose } from 'class-transformer';

export class OverviewVideoResponseDto {
  @Expose()
  thumbnail: string;

  @Expose()
  title: string;

  @Expose()
  category: string;

  @Expose()
  numberOfViews: number;

  @Expose()
  avgWatched: number;

  @Expose()
  rating: number;

  @Expose()
  publishedOn: Date;

  @Expose()
  numberOfReps: number;
}
