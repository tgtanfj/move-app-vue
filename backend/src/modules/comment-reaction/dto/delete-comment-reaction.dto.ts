import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber } from 'class-validator';

export class DeleteCommentReactionDto {
  @ApiProperty({
    description: 'id comment',
  })
  @IsNotEmpty()
  @IsNumber()
  commentId: number;
}
