import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';

export class AttachPaymentMethodDto {
  @IsNotEmpty()
  @ApiProperty({
    example: 'pm_1MqM05LkdIwHu7ixlDxxO6Mc',
  })
  paymentMethodId: string;
}
