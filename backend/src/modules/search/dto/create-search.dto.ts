import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateSearchHistoryDto {
  @ApiProperty({
    description: 'Content Search',
    example: 'David',
  })
  @IsString()
  @IsNotEmpty()
  content: string;
}
