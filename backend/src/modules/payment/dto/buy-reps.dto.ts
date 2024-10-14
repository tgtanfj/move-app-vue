import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber } from 'class-validator';

export class BuyREPsDto {
  @IsNotEmpty()
  @IsNumber()
  @ApiProperty({
    example: 1,
  })
  repPackageId: number;

  @IsNotEmpty()
  @ApiProperty({
    example: 'pm_1MqM05LkdIwHu7ixlDxxO6Mc',
  })
  paymentMethodId: string;
}
