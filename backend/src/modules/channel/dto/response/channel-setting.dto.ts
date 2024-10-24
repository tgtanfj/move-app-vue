import { Expose } from 'class-transformer';

export class ChannelSettingDto {
  @Expose()
  id: number;

  @Expose()
  bio: string;

  @Expose()
  socialLinks: SocialLink[];
}

export class SocialLink {
  name: 'facebook' | 'instagram' | 'youtube';

  link: string;
}
