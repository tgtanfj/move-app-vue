import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, Length } from 'class-validator';

export class ResendOtpDto {
  @IsNotEmpty()
  @IsEmail()
  @Length(5, 255)
  @ApiProperty({
    description: 'email of user',
    example: 'abc@gmail.com',
  })
  email: string;
}
