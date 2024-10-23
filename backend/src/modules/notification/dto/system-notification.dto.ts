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
    description: 'content notification',
  })
  @IsNotEmpty()
  content: string;

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
    description: 'purchase',
  })
  @IsOptional()
  purchase?: number;
}
