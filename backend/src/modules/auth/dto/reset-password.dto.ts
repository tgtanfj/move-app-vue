import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsStrongPassword, Length } from 'class-validator';

export class ResetPasswordDTO {
  @ApiProperty({
    description: 'token for reset password',
  })
  @IsNotEmpty()
  token: string;

  @ApiProperty({
    description: 'new password',
    example: '123456@Abc',
  })
  @IsStrongPassword()
  @Length(8, 32)
  newPassword: string;
}
