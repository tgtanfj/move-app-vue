import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsNumber, IsOptional } from 'class-validator';

export enum SortDirection {
  ASC = 'asc',
  DESC = 'desc',
}

export enum SortField {
  TOTAL_EARNING = 'totalEarnings',
  TOTAL_TOP_UP = 'totalTopUp',
  TOTAL_DONATION = 'totalDonations',
}

export default class RevenueRequestDto {
  @IsOptional()
  @ApiProperty({ name: 'search', example: '', required: false })
  search?: string;

  @IsOptional()
  @ApiPropertyOptional({ name: 'sortField', enum: SortField, required: false })
  sortField?: SortField;

  @IsOptional()
  @ApiPropertyOptional({ name: 'sortDirection', enum: SortDirection, required: false })
  sortDirection?: SortDirection;

  @IsNumber()
  @Type(() => Number)
  @ApiProperty({
    example: 10,
    required: false,
    default: 10,
  })
  @IsOptional()
  take: number = 10;

  @IsNumber()
  @Type(() => Number)
  @ApiProperty({
    example: 1,
    required: false,
    default: 1,
  })
  @IsOptional()
  page: number = 1;
}
