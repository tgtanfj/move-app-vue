import { Account } from '@/entities/account.entity';
import { User } from '@/entities/user.entity';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { SignUpEmailDto } from '../auth/dto/signup-email.dto';
import { UserProfile } from './dto/response/user-profile.dto';
import { UserRepository } from './user.repository';

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

  async findOneByEmail(email: string): Promise<User> {
    return await this.userRepository.findOneByEmail(email);
  }

  async createUserByEmail(signUpEmailDto: SignUpEmailDto): Promise<User> {
    return await this.userRepository.createUserByEmail(signUpEmailDto).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async createAccount(userId: number, password: string): Promise<Account> {
    return this.userRepository.createAccount(userId, password).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }
}
