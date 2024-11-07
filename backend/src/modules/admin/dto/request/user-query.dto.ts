import { Gender } from '@entities/enums/gender.enum';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsOptional } from 'class-validator';

export enum SortUserField {
  ID = 'id',
  FULL_NAME = 'fullName',
  EMAIL = 'email',
}

export default class UserQueryDto {
  @ApiPropertyOptional({
    name: 'contentSearch',
    description: 'Filter by content',
  })
  @IsOptional()
  contentSearch?: string;

  @ApiPropertyOptional({
    name: 'gender',
    enum: Gender,
  })
  @IsOptional()
  gender?: Gender;

  @ApiPropertyOptional({
    name: 'sortBy',
    enum: SortUserField,
    description: 'Sort by field',
  })
  @IsOptional()
  sortBy?: SortUserField;

  @ApiPropertyOptional({
    name: 'isAsc',
    description: 'Sort in ascending order if true',
    type: Boolean,
    default: true,
  })
  @IsOptional()
  @Transform(
    ({ value }) => {
      return value === 'true' || value === true;
    },
    { toPlainOnly: true },
  )
  isAsc?: boolean = true;

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
