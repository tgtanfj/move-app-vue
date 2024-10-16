import { Expose } from 'class-transformer';

export class GetCategoriesDTO {
  @Expose()
  id: number;

  @Expose()
  title: string;

  @Expose()
  image: string;

  @Expose()
  numberOfViews: string;
}
