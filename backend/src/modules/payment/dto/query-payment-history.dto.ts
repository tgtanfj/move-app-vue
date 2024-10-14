import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsDate, IsEmpty, IsNumber, IsOptional, Validate, ValidationArguments } from 'class-validator';

export default class QueryPaymentHistoryDto {
  @ApiProperty({
    required: false,
    type: Date,
    example: '1-1-2024',
    description: 'Start date of filter (MM-DD-YYYY)',
  })
  @IsOptional()
  @IsDate()
  @Type(() => Date)
  @Transform(
    ({ value }) => {
      if (!value) return null;
      const startDate = new Date(value);
      startDate.setHours(0, 0, 0, 0);
      return startDate.toISOString();
    },
    { toPlainOnly: true },
  )
  startDate?: Date | null = null;

  @ApiProperty({
    required: false,
    type: Date,
    example: '1-31-2024',
    description: 'End date of filter (MM-DD-YYYY)',
  })
  @IsOptional()
  @IsDate()
  @Type(() => Date)
  @Transform(
    ({ value }) => {
      if (!value) return null;
      const endDate = new Date(value);
      endDate.setHours(23, 59, 59, 999);
      return endDate.toISOString();
    },
    { toPlainOnly: true },
  )
  endDate?: Date | null = null;

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
