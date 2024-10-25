import {
  AnalyticSortBy,
  GraphicType,
  ShowBy,
  SortBy,
} from '@/modules/channel/dto/request/filter-video-channel.dto';
import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsBoolean, IsEnum, IsNotEmpty, IsNumber, IsOptional, IsString, Min } from 'class-validator';

export class VideosAnalyticDTO {
  @ApiProperty({
    enum: ShowBy,
  })
  @IsEnum(ShowBy)
  option: ShowBy = ShowBy.ALL_TIME;

  @ApiProperty({
    enum: AnalyticSortBy,
  })
  @IsEnum(AnalyticSortBy)
  sortBy: AnalyticSortBy = AnalyticSortBy.ALL;

  @ApiProperty({
    example: 'false',
    required: false,
  })
  @IsString()
  @IsOptional()
  asc?: string = 'false';

  @ApiProperty({
    example: '1',
  })
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  page?: number = 1;

  @ApiProperty({
    example: '10',
  })
  @Type(() => Number)
  @IsNumber()
  @Min(10)
  take?: number = 10;
}
