import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';

export class CreateCommentDto {
  @ApiProperty({
    description: 'comment content',
    example: 'comment 1',
  })
  @IsNotEmpty()
  @IsString()
  content: string;

  @ApiProperty({
    description: 'id video ',
  })
  @IsNotEmpty()
  @IsNumber()
  videoId: number;

  @ApiProperty({
    description: 'id comment parent',
  })
  @IsOptional()
  @IsNumber()
  commentId?: number;
}
