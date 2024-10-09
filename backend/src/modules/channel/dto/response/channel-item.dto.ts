import { Expose } from 'class-transformer';

export class ChannelItemDto {
  @Expose()
  id: number;

  @Expose()
  name: string;

  @Expose()
  image: string;

  @Expose()
  isBlueBadge: boolean;

  @Expose()
  isPinkBadge: boolean;

  @Expose()
  numberOfFollowers: number;
}
