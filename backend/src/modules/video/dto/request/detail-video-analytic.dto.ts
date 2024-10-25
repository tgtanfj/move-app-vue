import { GraphicType, ShowBy } from '@/modules/channel/dto/request/filter-video-channel.dto';
import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty, IsNumber, IsOptional } from 'class-validator';

export class DetailVideoAnalyticDTO {
  @ApiProperty({
    enum: ShowBy,
  })
  @IsEnum(ShowBy)
  option: ShowBy = ShowBy.ALL_TIME;

  @ApiProperty({
    enum: GraphicType,
    required: false,
  })
  @IsOptional()
  @IsEnum(GraphicType)
  graphic: GraphicType = GraphicType.GENDER;
}
