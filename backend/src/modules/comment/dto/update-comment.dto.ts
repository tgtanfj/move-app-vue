import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsOptional, IsString } from 'class-validator';

export class UpdateCommentDto {
  @ApiProperty({
    description: 'comment content',
    example: 'comment 2',
  })
  @IsOptional()
  @IsString()
  content: string;

  @IsOptional()
  @IsNumber()
  commentId?: number;
}
