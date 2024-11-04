import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';

enum SortDirection {
  ASC = 'asc',
  DESC = 'desc',
}

export default class PaymentSortFieldDto {
  @IsOptional()
  @ApiPropertyOptional({ name: 'createdAt', enum: SortDirection, required: false })
  createdAt?: SortDirection = undefined;

  @IsOptional()
  @ApiPropertyOptional({ name: 'numberOfREPs', enum: SortDirection, required: false })
  numberOfREPs?: SortDirection = undefined;
}
