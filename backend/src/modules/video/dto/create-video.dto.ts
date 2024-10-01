import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, Max } from 'class-validator';

// validation file size before return upload link
export class CreateVideoDTO {
  @ApiProperty({
    description: 'file size',
    example: '5002082',
  })
  @IsNotEmpty()
  @Max(52428800)
  fileSize: number;
}
