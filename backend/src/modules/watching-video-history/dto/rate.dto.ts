import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';

export class RateDto {
  @ApiProperty({
    description: 'Rate value',
    example: 4,
  })
  @IsNotEmpty()
  @IsNumber()
  rate: number;

  @ApiProperty({
    description: 'id video',
  })
  @IsNotEmpty()
  @IsNumber()
  videoId: number;
}
