import { User } from '@/entities/user.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { InjectRepository } from '@nestjs/typeorm';
import { Equal, Repository } from 'typeorm';
import { Injectable } from '@nestjs/common';

@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(User)
    readonly userRepository: Repository<User>,
  ) {}

  async findOne(id: number): Promise<User> {
    const foundUser = await this.userRepository.findOneBy({
      id: Equal(id),
    });

    if (!foundUser) throw new Error(ERRORS_DICTIONARY.NOT_FOUND_ANY_USER);

    return foundUser;
  }

  async findAll(): Promise<User[]> {
    return this.userRepository.find();
  }
}
