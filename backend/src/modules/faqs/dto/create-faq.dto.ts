import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { IsOptional, IsString } from 'class-validator';

export class CreateFaqDto {
  @ApiProperty({
    description: 'type of question',
    example: 'S',
  })
  @IsString()
  question: string;

  @ApiProperty({
    description: 'content of question',
    example: 'cong thuc abc la:',
  })
  @IsString()
  answer: string;

  @IsString()
  @IsOptional()
  isActive?: string;
}
