import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { RefreshToken } from '@/entities/refresh-token.entity';
import { User } from '@/entities/user.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Injectable, NotFoundException, Delete } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeleteResult, Equal, FindOptionsRelations, Repository, UpdateResult } from 'typeorm';
import { Account } from '../../entities/account.entity';
import { SignUpEmailDto } from '../auth/dto/signup-email.dto';
import { SignUpSocialDto } from '../auth/dto/signup-social.dto';

@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Account)
    private readonly accountRepository: Repository<Account>,
    @InjectRepository(RefreshToken)
    private readonly tokenRepository: Repository<RefreshToken>,
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

  async findUserAccountWithEmail(email: string): Promise<User> {
    const user = await this.userRepository.findOne({
      where: { email: email },
      relations: ['account'],
    });
    return user;
  }

  async createUserByEmail(signUpEmailDto: SignUpEmailDto): Promise<User> {
    const { email, stripeId } = signUpEmailDto;

    return await this.userRepository.save({ email, stripeId });
  }

  async createUserBySocial(signUpDto: SignUpSocialDto): Promise<User> {
    return await this.userRepository.save({ ...signUpDto, isActive: true });
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
    if (!foundUser)
      throw new NotFoundException({
        message: ERRORS_DICTIONARY.USER_NOT_FOUND,
        email,
      });
    return foundUser;
  }
  async createAccountSocial(userId: number, type: TypeAccount): Promise<Account> {
    const accountCreated = this.accountRepository.create({
      user: {
        id: userId,
      },
      type,
    });
    return await this.accountRepository.save(accountCreated);
  }

  async findOneAccount(userId: number): Promise<Account> {
    return await this.accountRepository.findOneByOrFail({
      user: {
        id: userId,
      },
    });
  }

  async saveFreshToken(userId: number, deviceInfo: any, refreshToken: string): Promise<RefreshToken> {
    const refreshTokenSaved = this.tokenRepository.create({
      user: { id: userId },
      refreshToken,
      ipAddress: deviceInfo.ipAddress,
      userAgent: deviceInfo.userAgent,
    });

    return await this.tokenRepository.save(refreshTokenSaved);
  }

  async validateRefreshToken(refreshToken: string): Promise<RefreshToken> {
    return await this.tokenRepository.findOneByOrFail({ refreshToken });
  }

  async revokeRefreshToken(refreshToken: string): Promise<DeleteResult> {
    return await this.tokenRepository.delete({ refreshToken });
  }
}
