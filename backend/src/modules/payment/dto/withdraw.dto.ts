import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsEmail, IsNotEmpty, IsNumber, IsOptional } from 'class-validator';

export class WithDrawDto {
  @IsOptional()
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

  @IsOptional()
  @IsBoolean()
  @ApiProperty({
    example: true,
  })
  isSave: true;
}
