import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsStrongPassword, Length } from 'class-validator';

export class ChangePasswordDTO {
  @ApiProperty({
    description: 'current password',
  })
  @IsNotEmpty()
  currentPassword: string;

  @ApiProperty({
    description: 'new password',
    example: '123456@Abc',
  })
  @IsStrongPassword()
  @Length(8, 32)
  newPassword: string;
}
