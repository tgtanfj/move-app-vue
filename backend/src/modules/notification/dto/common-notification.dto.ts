import { UserInfoDto } from '@/modules/user/dto/user-info.dto';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional } from 'class-validator';

export class CommonNotificationDto {
  @ApiProperty({
    description: 'sender notification',
  })
  @IsNotEmpty()
  sender: UserInfoDto;

  @ApiProperty({
    description: 'type notification',
  })
  @IsNotEmpty()
  type: NOTIFICATION_TYPE;

  @ApiPropertyOptional({
    description: 'id video',
  })
  @IsOptional()
  videoId?: number;

  @ApiPropertyOptional({
    description: 'video title',
  })
  @IsOptional()
  videoTitle?: string;

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
