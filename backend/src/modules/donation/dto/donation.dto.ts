import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class DonationDto {
  @IsNotEmpty()
  @IsNumber()
  @ApiProperty({
    example: 1,
  })
  giftPackageId: number;

  @IsNotEmpty()
  @IsString()
  @ApiProperty({
    example: 'Well done',
  })
  content: string;

  @IsNotEmpty()
  @IsNumber()
  @ApiProperty({
    example: 1,
  })
  videoId: number;
}
