import { Gender } from '@/entities/enums/gender.enum';
import { Role } from '@/entities/enums/role.enum';
import { ApiProperty } from '@nestjs/swagger';
import { IsDate, IsEmail } from 'class-validator';

export class CreateUserDto {
  @ApiProperty()
  @IsEmail()
  email: string;

  @ApiProperty()
  username: string = '12561256';

  @IsDate()
  @ApiProperty()
  dateOfBirth: Date = new Date();

  gender: Gender = Gender.MALE;

  role: Role = Role.VIEWER;

  @ApiProperty()
  fullName: string;
}
