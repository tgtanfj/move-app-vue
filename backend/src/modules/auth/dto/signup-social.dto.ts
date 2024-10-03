import { IsNotEmpty, IsString } from 'class-validator';
import { SignUpDto } from './signup.dto';

export class SignUpSocialDto extends SignUpDto {
  @IsNotEmpty()
  @IsString()
  fullName: string;

  @IsNotEmpty()
  @IsString()
  avatar: string;

  @IsNotEmpty()
  @IsString()
  username: string;
}
