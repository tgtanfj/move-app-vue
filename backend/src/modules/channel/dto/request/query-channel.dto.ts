import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsNumber } from 'class-validator';
import { FilterWorkoutLevel, SortBy } from './filter-video-channel.dto';

export class QueryChannelDto {
  @ApiProperty({ name: 'workout-level', enum: FilterWorkoutLevel, required: false })
  workoutLevel: FilterWorkoutLevel = FilterWorkoutLevel.ALL_LEVEL;

  @ApiProperty({ name: 'sort-by', enum: SortBy, required: false })
  sortBy: SortBy = SortBy.MOST_RECENT;

  @ApiProperty({ name: 'categoryId', type: Number, required: false })
  categoryId: number = undefined;

  @ApiProperty({ name: 'take', type: Number, required: false })
  @Type(() => Number)
  @IsNumber()
  take: number = 6;

  @ApiProperty({ name: 'page', type: Number, required: false })
  @Type(() => Number)
  @IsNumber()
  page: number = 1;
}
