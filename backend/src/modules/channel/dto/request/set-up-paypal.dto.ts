import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class SetUpPayPalDto {
  @IsNotEmpty()
  @IsEmail()
  @ApiProperty({
    example: 'sb-xxzoh33299105@personal.example.com',
  })
  emailPayPal: string;
}
