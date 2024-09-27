import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class SocialTokenDto {
  @ApiProperty({
    name: 'idToken',
    type: String,
    description: 'Token',
  })
  @IsNotEmpty()
  @IsString()
  idToken: string;
}
