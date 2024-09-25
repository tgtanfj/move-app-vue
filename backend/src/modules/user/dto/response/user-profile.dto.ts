import { Country } from '@/entities/country.entity';
import { Gender } from '@/entities/enums/gender.enum';
import { State } from '@/entities/state.entity';
import { Expose } from 'class-transformer';
import { IsEmail } from 'class-validator';

export class UserProfile {
  @Expose()
  readonly avatar: string;

  @Expose()
  readonly username: string;

  @Expose()
  @IsEmail()
  readonly email: string;

  @Expose()
  readonly fullName: string;

  @Expose()
  readonly gender: Gender;

  @Expose()
  readonly dateOfBirth: Date;

  @Expose()
  readonly country: Country;

  @Expose()
  readonly state: State;

  @Expose()
  readonly city: string;
}
