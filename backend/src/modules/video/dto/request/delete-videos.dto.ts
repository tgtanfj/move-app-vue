import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsArray } from 'class-validator';

export class DeleteVideosDto {
  @ApiProperty({
    example: [1, 2],
  })
  @IsArray()
  @Type(() => Number)
  videoIds: number[];
}
