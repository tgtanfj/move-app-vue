import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber } from 'class-validator';

export class CreateFollowDto {
  @ApiProperty({
    example: '3',
  })
  @IsNumber()
  @IsNotEmpty()
  channelId: number;
}
