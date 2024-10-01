import { Expose } from 'class-transformer';

export class CategoryVideoDetailDto {
  @Expose()
  id: number;

  @Expose()
  title: number;
}
