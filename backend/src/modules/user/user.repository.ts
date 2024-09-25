import { User } from '@/entities/user.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { InjectRepository } from '@nestjs/typeorm';
import { Equal, FindOptionsRelations, Repository } from 'typeorm';
import { Injectable } from '@nestjs/common';

@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(User)
    readonly userRepository: Repository<User>,
  ) {}

  async findOne(id: number, relations: FindOptionsRelations<User> = null): Promise<User> {
    const foundUser = await this.userRepository.findOne({
      where: {
        id: Equal(id),
      },
      relations: relations,
    });

    if (!foundUser) throw new Error(ERRORS_DICTIONARY.NOT_FOUND_ANY_USER);

    return foundUser;
  }

  async findAll(): Promise<User[]> {
    return this.userRepository.find();
  }
}
