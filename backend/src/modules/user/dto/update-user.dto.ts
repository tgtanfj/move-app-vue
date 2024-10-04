import { Gender } from '@/entities/enums/gender.enum';
import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsOptional, Length, Matches } from 'class-validator';

export class UpdateUserDto {
  @ApiProperty({ type: 'string', format: 'binary', required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  avatar?: any;

  @ApiProperty({ example: 'Johndoe2k1', required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  username?: string;

  @ApiProperty({ example: '2001-01-02', required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  dateOfBirth?: Date;

  @ApiProperty({ example: Gender.MALE, required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  gender?: Gender;

  @ApiProperty({ example: 'John Doe', required: false })
  @IsOptional()
  @Length(8, 255, { message: 'Full name must be between 8 and 255 characters' })
  @Matches(/^[a-zA-Z\s]+$/, { message: 'Full name must not contain special characters' })
  @Transform(({ value }) => (value === '' ? undefined : value))
  fullName?: string;

  @ApiProperty({ example: 1, required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  countryId?: number;

  @ApiProperty({ example: 10, required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  stateId?: number;

  @ApiProperty({ example: 'New York', required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  city?: string;

  @IsOptional()
  isActive?: boolean;
}
