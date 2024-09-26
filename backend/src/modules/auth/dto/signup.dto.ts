import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsOptional, Length } from 'class-validator';

export class SignUpDto {
  @IsNotEmpty()
  @IsEmail()
  @Length(5, 255)
  @ApiProperty({
    description: 'email of user',
    example: 'abc@gmail.com',
  })
  email: string;

  @IsOptional()
  stripeId: string;
}
