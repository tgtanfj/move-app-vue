import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, Length } from 'class-validator';

export class ForgotPasswordDTO {
  @IsEmail()
  @IsNotEmpty()
  @Length(5, 255)
  @ApiProperty({
    description: 'forgot password',
    example: '@gmail.com',
  })
  email: string;
}
