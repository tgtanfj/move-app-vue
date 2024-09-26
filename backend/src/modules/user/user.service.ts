import { User } from '@/entities/user.entity';
import { IBaseService } from '@/shared/interfaces/commons/IBaseService';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { UserRepository } from './user.repository';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserProfile } from './dto/response/user-profile.dto';
import { plainToClass, plainToInstance } from 'class-transformer';

@Injectable()
export class UserService {
  constructor(private readonly userRepository: UserRepository) {}

  async findOne(id: number): Promise<User> {
    return await this.userRepository.findOne(id).catch((error) => {
      throw new NotFoundException(error.message);
    });
  }

  async findAll(): Promise<User[]> {
    return await this.userRepository.findAll().catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async getProfile(id: number): Promise<UserProfile> {
    const relations = { country: true, state: true };
    const foundUser = this.userRepository.findOne(id, relations);

    return plainToInstance(UserProfile, foundUser, { excludeExtraneousValues: true });
  }
}
