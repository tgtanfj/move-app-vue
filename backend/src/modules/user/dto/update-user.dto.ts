import { Gender } from '@/entities/enums/gender.enum';
import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsOptional, Length, Matches, Validate } from 'class-validator';
import { isBefore, subYears } from 'date-fns';
import { ValidatorConstraint, ValidatorConstraintInterface } from 'class-validator';

@ValidatorConstraint({ async: false })
class DateOfBirthValidator implements ValidatorConstraintInterface {
  validate(dateOfBirth: Date | undefined): boolean {
    if (dateOfBirth === undefined) return true;

    const today = new Date();
    const maxDate = subYears(today, 13);
    const minDate = subYears(today, 65);

    return isBefore(dateOfBirth, maxDate) && isBefore(minDate, dateOfBirth);
  }
}

export class UpdateUserDto {
  @ApiProperty({ type: 'string', format: 'binary', required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  avatar?: any;

  @ApiProperty({ example: 'Johndoe2k1', required: false })
  @IsOptional()
  @Length(4, 25)
  @Transform(({ value }) => (value === '' ? undefined : value))
  username?: string;

  @ApiProperty({ example: '2001-01-02', required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  @Validate(DateOfBirthValidator, {
    message: 'Date of birth must be valid and user must be between 13 and 65 years old.',
  })
  dateOfBirth?: Date;

  @ApiProperty({ example: Gender.MALE, required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? undefined : value))
  gender?: Gender;

  @ApiProperty({ example: 'John Doe', required: false })
  @IsOptional()
  @Length(8, 255, { message: 'Full name must be between 8 and 255 characters' })
  @Matches(/^[a-zA-ZÀ-ỹ\s]+$/, { message: 'Full name must not contain special characters or numbers' })
  @Transform(({ value }) => (value === '' ? undefined : value))
  fullName?: string;

  @ApiProperty({ example: 1, required: false })
  @IsOptional()
  countryId?: number;

  @ApiProperty({ example: 10, required: false })
  @IsOptional()
  stateId?: number;

  @ApiProperty({ example: 'New York', required: false })
  @IsOptional()
  @Transform(({ value }) => (value === '' ? null : value))
  city?: string;

  @IsOptional()
  isActive?: boolean;
}
