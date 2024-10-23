import { ShowBy } from '@/modules/channel/dto/request/filter-video-channel.dto';
import { IsEnum, IsNotEmpty, IsNumber } from 'class-validator';

export class DetailVideoAnalyticDTO {
  @IsEnum(ShowBy)
  option: ShowBy = ShowBy.ALL_TIME;
}
