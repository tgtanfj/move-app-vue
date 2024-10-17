import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, IsUrl, ValidateIf } from 'class-validator';

export class EditChannelDto {
  @ApiProperty({ example: 'This Bio' })
  @IsString()
  @IsOptional()
  bio: string;

  @ApiProperty({ example: 'youtube.com' })
  @IsOptional()
  @IsUrl()
  @ValidateIf((o) => o.youtubeLink && o.youtubeLink.includes('youtube.com'))
  youtubeLink: string;

  @ApiProperty({ example: 'facebook.com' })
  @IsOptional()
  @IsUrl()
  @ValidateIf((o) => o.youtubeLink && o.youtubeLink.includes('facebook.com'))
  facebookLink: string;

  @ApiProperty({ example: 'instagram.com' })
  @IsOptional()
  @IsUrl()
  @ValidateIf((o) => o.youtubeLink && o.youtubeLink.includes('instagram.com'))
  instagramLink: string;
}
