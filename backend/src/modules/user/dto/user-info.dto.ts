import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';

export class UserInfoDto {
  @ApiProperty({
    description: 'user id',
    example: 1,
  })
  @IsNotEmpty()
  id: number;

  @ApiProperty({
    description: 'user name',
  })
  @IsNotEmpty()
  username: string;

  @ApiProperty({
    description: 'user avatar',
  })
  @IsNotEmpty()
  avatar: string;
}
