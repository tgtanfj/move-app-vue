import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsNotEmpty } from 'class-validator';

export class DownloadMultiDTO {
  @ApiProperty({
    example: [222, 221],
  })
  @IsArray()
  @IsNotEmpty()
  arrayUrl: number[];
}
