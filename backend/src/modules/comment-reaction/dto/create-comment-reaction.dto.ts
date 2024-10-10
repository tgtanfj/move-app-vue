import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsNotEmpty, IsNumber } from 'class-validator';

export class CreateCommentReactionDto {
  @ApiProperty({
    example: true,
  })
  @IsNotEmpty()
  @IsBoolean()
  isLike: boolean;

  @ApiProperty({
    description: 'id comment',
  })
  @IsNotEmpty()
  @IsNumber()
  commentId: number;
}
