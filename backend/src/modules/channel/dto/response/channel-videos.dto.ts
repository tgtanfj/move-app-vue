import { Expose } from 'class-transformer';
import { ChannelItemDto } from './channel-item.dto';
import { VideoItemDto } from '@/modules/video/dto/response/video-item.dto';
import { SocialLink } from './channel-profile.dto';

export class ChannelVideosDto {
  @Expose()
  videos: VideoItemDto[];
}
