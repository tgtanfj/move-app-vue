import { DurationType } from '@/entities/enums/durationType.enum';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsEnum, IsNotEmpty, IsString, MaxLength, MinLength } from 'class-validator';

export class EditVideoDTO {
  @ApiProperty({
    description: 'Title of video',
    example: 'Pro ex',
  })
  @IsString()
  @IsNotEmpty({ message: 'Title is required and cannot be empty.' })
  @MinLength(1, { message: 'Title must be at least 1 character long.' })
  @MaxLength(100, { message: 'Title cannot be longer than 100 characters.' })
  title: string;

  @ApiProperty({
    description: 'category of video',
    example: 3,
  })
  @IsNotEmpty()
  categoryId: number;

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
  @MaxLength(500, { message: 'Keywords should not exceed 500 characters' })
  keywords: string;

  @IsString()
  isCommentable: string;
}
