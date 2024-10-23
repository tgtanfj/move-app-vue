import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';
import { CommonNotificationDto } from './common-notification.dto';

export class NotificationOneToManyDto {
  @ApiProperty({
    description: 'user ids received notification',
    example: [1, 2, 3],
  })
  @IsNotEmpty()
  userIds: number[];

  @ApiProperty({
    description: 'data received notification',
  })
  @IsNotEmpty()
  data: CommonNotificationDto;
}
