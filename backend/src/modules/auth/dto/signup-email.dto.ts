import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsStrongPassword, Length } from 'class-validator';
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
}
