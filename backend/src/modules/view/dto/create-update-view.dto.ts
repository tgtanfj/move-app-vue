import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsOptional } from 'class-validator';

export class CreateUpdateViewDto {
  @ApiProperty({
    description: 'video id',
  })
  @IsNotEmpty()
  @IsNumber()
  videoId: number;

  @ApiProperty({
    description: 'the day watch video',
    example: '2024-10-25',
  })
  @IsOptional()
  date: Date;

  @ApiProperty({
    description: 'time watch video',
  })
  @IsOptional()
  @IsNumber()
  viewTime?: number;
}
