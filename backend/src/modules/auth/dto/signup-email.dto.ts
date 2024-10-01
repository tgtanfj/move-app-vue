import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString, IsStrongPassword, Length } from 'class-validator';
import { SignUpDto } from './signup.dto';

export class SignUpEmailDto extends SignUpDto {
  @IsNotEmpty()
  @Length(8, 32)
  @IsStrongPassword()
  @ApiProperty({
    description: 'password of user',
    example: '123456@Abc',
  })
  password: string;

  @IsOptional()
  @ApiProperty({
    description: 'Referral Code',
    example: '312341',
  })
  referralCode: string;

  @IsNotEmpty()
  @IsString()
  @ApiProperty({
    description: 'otp',
    example: '123456',
  })
  otp: string;

  @IsOptional()
  username: string;
}
