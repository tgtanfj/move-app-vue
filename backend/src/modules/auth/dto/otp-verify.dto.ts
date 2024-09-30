import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class OtpVerifyDto {
  @IsNotEmpty()
  @IsString()
  @ApiProperty({
    description: 'otp',
    example: '123456',
  })
  otp: string;
}
