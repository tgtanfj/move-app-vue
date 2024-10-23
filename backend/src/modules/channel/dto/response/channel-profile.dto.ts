import { Expose } from 'class-transformer';
import { ChannelItemDto } from './channel-item.dto';

export class SocialLink {
  name: 'facebook' | 'instagram' | 'youtube';

  link: string;
}

export class ChannelProfileDto {
  @Expose()
  name: string;

  @Expose()
  bio: string;

  @Expose()
  image: string;

  @Expose()
  isBlueBadge: boolean;

  @Expose()
  isPinkBadge: boolean;

  @Expose()
  socialLinks: SocialLink[];

  @Expose()
  numberOfFollowers: number;

  @Expose()
  isFollowed: boolean | null = null;

  @Expose()
  canFollow: boolean | null = null;

  @Expose()
  followingChannels: ChannelItemDto[];
}
