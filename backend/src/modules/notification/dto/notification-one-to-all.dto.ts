import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';
import { SystemNotificationDto } from './system-notification.dto';

export class NotificationOneToAllDto {
  @ApiProperty({
    description: 'data received notification',
  })
  @IsNotEmpty()
  data: SystemNotificationDto;
}
