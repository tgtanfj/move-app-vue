import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional } from 'class-validator';

export class SystemNotificationDto {
  @ApiProperty({
    description: 'sender notification',
    example: 'system',
  })
  @IsNotEmpty()
  sender: string;

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
    description: 'cashout',
  })
  @IsOptional()
  cashout?: number;

  @ApiPropertyOptional({
    description: 'follow milestone',
  })
  @IsOptional()
  followMilestone?: number;

  @ApiPropertyOptional({
    description: 'rep milestone',
  })
  @IsOptional()
  repMilestone?: number;

  @ApiPropertyOptional({
    description: 'view video milestone',
  })
  @IsOptional()
  viewVideoMilestone?: number;

  @ApiPropertyOptional({
    description: 'purchase',
  })
  @IsOptional()
  purchase?: number;
}
