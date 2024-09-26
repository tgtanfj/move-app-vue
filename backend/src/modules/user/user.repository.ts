import { User } from '@/entities/user.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Equal, FindOptionsRelations, Repository } from 'typeorm';
import { Account } from '../../entities/account.entity';
import { SignUpEmailDto } from '../auth/dto/signup-email.dto';
import { NotFoundError } from 'rxjs';

@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Account)
    private readonly accountRepository: Repository<Account>,
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

  async findOneByEmail(email: string): Promise<User> {
    const foundUser = await this.userRepository.findOneBy({
      email,
    });

    return foundUser;
  }

  async createUserByEmail(signUpEmailDto: SignUpEmailDto): Promise<User> {
    const { email, stripeId } = signUpEmailDto;

    return await this.userRepository.save({ email, stripeId });
  }

  async createAccount(userId: number, password: string): Promise<Account> {
    const accountCreated = this.accountRepository.create({
      user: {
        id: userId,
      },
      password,
    });
    return await this.accountRepository.save(accountCreated);
  }
  async getOneUserByEmailOrThrow(email: string): Promise<User> {
    const foundUser = await this.userRepository.findOne({
      where: {
        email: email,
      },
    });
    if (!foundUser) throw new NotFoundException({
      message: ERRORS_DICTIONARY.USER_NOT_FOUND,
      email
    });
    return foundUser;
  }
}
