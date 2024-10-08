import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsNotEmpty } from 'class-validator';

export class UpdateCommentReactionDto {
  @ApiProperty({
    example: true,
  })
  @IsNotEmpty()
  @IsBoolean()
  isLike: boolean;
}
