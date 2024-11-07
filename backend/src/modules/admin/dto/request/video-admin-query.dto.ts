import { DurationType } from '@/entities/enums/durationType.enum';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsOptional } from 'class-validator';

export enum SortVideoAdmin {
  TITLE = 'title',
  VIEWS = 'numberOfViews',
  COMMENT = 'numberOfComments',
  RATINGS = 'ratings',
  CREATED_AT = 'createdAt',
}

export enum SortType {
  ASC = 'ASC',
  DESC = 'DESC',
}

export default class VideoAdminQueryDto {
  @ApiPropertyOptional({
    name: 'query',
  })
  @IsOptional()
  query?: string;

  @ApiPropertyOptional({
    name: 'workoutLevel',
    enum: WorkoutLevel,
  })
  @IsOptional()
  workoutLevel?: WorkoutLevel;

  @ApiPropertyOptional({
    name: 'duration',
    enum: DurationType,
  })
  @IsOptional()
  duration?: DurationType;

  @ApiPropertyOptional({
    name: 'sortBy',
    enum: SortVideoAdmin,
    description: 'Sort by field',
  })
  @IsOptional()
  sortBy?: SortVideoAdmin;

  @ApiPropertyOptional({
    name: 'sortType',
    description: 'Sort in ascending order if true',
    enum: SortType,
  })
  @IsOptional()
  sortType?: SortType;

  @ApiPropertyOptional({
    name: 'take',
    description: 'Number of records to retrieve',
    type: Number,
  })
  @IsOptional()
  @Transform(
    ({ value }) => {
      return +value;
    },
    { toPlainOnly: true },
  )
  take?: number = 10;

  @ApiPropertyOptional({
    name: 'page',
    description: 'Page number for pagination',
    type: Number,
  })
  @IsOptional()
  @Transform(
    ({ value }) => {
      return +value;
    },
    { toPlainOnly: true },
  )
  page?: number = 1;
}
