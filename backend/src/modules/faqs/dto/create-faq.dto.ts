import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { IsBoolean, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateFaqDto {
  @ApiProperty({
    description: 'type of question',
    example: 'S',
  })
  @Expose()
  @IsString()
  question: string;

  @ApiProperty({
    description: 'content of question',
    example: 'cong thuc abc la:',
  })
  @Expose()
  @IsString()
  answer: string;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}
