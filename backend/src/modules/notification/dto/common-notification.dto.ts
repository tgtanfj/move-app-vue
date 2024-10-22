import { UserInfoDto } from '@/modules/user/dto/user-info.dto';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional } from 'class-validator';

export class CommonNotificationDto {
  @ApiProperty({
    description: 'sender notification',
  })
  @IsNotEmpty()
  sender: UserInfoDto;

  @ApiProperty({
    description: 'content notification',
  })
  @IsNotEmpty()
  content: string;

  @ApiProperty({
    description: 'id video',
  })
  @IsNotEmpty()
  videoId: number;

  @ApiProperty({
    description: 'video title',
  })
  @IsNotEmpty()
  videoTitle: string;

  @ApiPropertyOptional({
    description: 'id comment',
  })
  @IsOptional()
  commentId?: number;

  @ApiPropertyOptional({
    description: 'comment content',
  })
  @IsOptional()
  commentContent?: string;

  @ApiPropertyOptional({
    description: 'id reply',
  })
  @IsOptional()
  replyId?: number;

  @ApiPropertyOptional({
    description: 'donated',
  })
  @IsOptional()
  donation?: number;
}
