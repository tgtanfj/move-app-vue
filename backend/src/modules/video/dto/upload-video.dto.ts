import { DurationType } from "@/entities/enums/durationType.enum";
import { WorkoutLevel } from "@/entities/enums/workoutLevel.enum";
import { ApiProperty } from "@nestjs/swagger";
import { IsBoolean, IsEnum, IsNotEmpty, IsString } from "class-validator"

export class UploadVideoDTO {
  @ApiProperty({
    description: 'Title of video',
    example: 'Pro ex',
  })
  @IsString()
  title: string;

  @ApiProperty({
    description: 'category of video',
    example: 3,
  })
  @IsNotEmpty()
  category: number;

  @ApiProperty({
    description: 'WorkoutLevel of video',
    example: 'beginner',
  })
  @IsEnum(WorkoutLevel)
  workoutLevel: WorkoutLevel;

  @ApiProperty({
    description: 'duration of video',
    example: 'less than 30 minutes',
  })
  @IsEnum(DurationType)
  duration: DurationType;

  @ApiProperty({
    description: 'keywords of video',
    example: 'abc,asdasd,proooo',
  })
  @IsString()
  keywords: string;

  @ApiProperty({
    description: 'Commentable video',
    example: true,
  })
  @IsString()
  @IsBoolean()
  isCommentable: boolean = true;

  @ApiProperty({
    description: 'Publish  video',
    example: true,
  })
  @IsBoolean()
  isPublish: boolean = false;

  @ApiProperty({
    description: 'url of video',
  })
  @IsString()
  url: string;
}