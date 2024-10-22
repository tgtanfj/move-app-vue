import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';
import { CommonNotificationDto } from './common-notification.dto';
import { SystemNotificationDto } from './system-notification.dto';

export class NotificationOneToOneDto {
  @ApiProperty({
    description: 'user id received notification',
    example: 1,
  })
  @IsNotEmpty()
  userId: number;

  @ApiProperty({
    description: 'data received notification',
  })
  @IsNotEmpty()
  data: CommonNotificationDto | SystemNotificationDto;
}
