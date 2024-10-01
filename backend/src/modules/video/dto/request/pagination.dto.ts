import { ApiProperty, ApiQuery } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsNumber } from 'class-validator';

export class PaginationDto {
  @ApiProperty({ required: false, default: 10 })
  @IsNumber()
  @Type(() => Number)
  take: number = 10;

  @ApiProperty({ required: false, default: 1 })
  @IsNumber()
  @Type(() => Number)
  page: number = 1;

  constructor(take?: number, page?: number) {
    this.take = take ?? this.take;
    this.page = page ?? this.page;
  }

  static getSkip(take?: number, page?: number) {
    return (page - 1) * take;
  }
}
