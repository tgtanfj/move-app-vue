import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsNumber } from 'class-validator';

export class WithDrawDto {
  @IsNotEmpty()
  @IsEmail()
  @ApiProperty({
    example: 'sb-xxzoh33299105@personal.example.com',
  })
  email: string;

  @IsNotEmpty()
  @IsNumber()
  @ApiProperty({
    example: 100,
  })
  numberOfREPs: number;
}
