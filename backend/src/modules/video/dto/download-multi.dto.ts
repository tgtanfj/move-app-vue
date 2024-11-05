import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsNotEmpty } from 'class-validator';

export class DownloadMultiDTO {
  @ApiProperty({
    example: [
      'https://move-project.s3.us-east-1.amazonaws.com/videos/1730695129930-1730695128433-workoutsmalllll.mp4',
      'https://move-project.s3.us-east-1.amazonaws.com/videos/1730694148682-1730694146421-Vip pro PT.mp4',
      'https://move-project.s3.us-east-1.amazonaws.com/videos/1730637964578-1730637962385-bug channel profile.mp4',
    ],
  })
  @IsArray()
  @IsNotEmpty()
  arrayUrl: string[];
}
