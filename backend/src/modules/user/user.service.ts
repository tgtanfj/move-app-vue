import { Account } from '@/entities/account.entity';
import { RefreshToken } from '@/entities/refresh-token.entity';
import { User } from '@/entities/user.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { DeleteResult, UpdateResult } from 'typeorm';
import { SignUpEmailDto } from '../auth/dto/signup-email.dto';
import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { SignUpSocialDto } from '../auth/dto/signup-social.dto';
import { UserProfile } from './dto/response/user-profile.dto';
import { AccountRepository } from './repositories/account.repository';
import { RefreshTokenRepository } from './repositories/refresh-token.repository';
import { UserRepository } from './repositories/user.repository';

@Injectable()
export class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly accountRepository: AccountRepository,
    private readonly refreshTokenRepository: RefreshTokenRepository,
  ) {}

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

  async findUserAccountWithEmail(email: string): Promise<User> {
    return await this.userRepository.findUserAccountWithEmail(email);
  }

  async createUserByEmail(signUpEmailDto: SignUpEmailDto): Promise<User> {
    return await this.userRepository.createUserByEmail(signUpEmailDto).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async createUserBySocial(signUpDto: SignUpSocialDto): Promise<User> {
    return await this.userRepository.createUserBySocial(signUpDto).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async createAccount(userId: number, password: string): Promise<Account> {
    return this.accountRepository.createAccount(userId, password).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }
  async getOneUserByEmailOrThrow(email: string): Promise<User> {
    return await this.userRepository.getOneUserByEmailOrThrow(email);
  }
  async updatePassword(newPassword: string, userId: number) {
    const foundAccount = await this.accountRepository.findOneAccount(userId);

    if (!foundAccount) {
      throw new BadRequestException({
        message: ERRORS_DICTIONARY.NOT_FOUND_ACCOUNT,
      });
    }

    foundAccount.oldPassword = foundAccount.password;
    foundAccount.password = newPassword;

    return await this.accountRepository.saveAccount(foundAccount);
  }
  async createAccountSocial(userId: number, type: TypeAccount): Promise<Account> {
    return this.accountRepository.createAccountSocial(userId, type).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async findOneAccount(userId: number): Promise<Account> {
    return this.accountRepository.findOneAccount(userId).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async saveRefreshToken(userId: number, deviceInfo: any, refreshToken: string): Promise<RefreshToken> {
    return await this.refreshTokenRepository
      .saveFreshToken(userId, deviceInfo, refreshToken)
      .catch((error) => {
        throw new BadRequestException(error.message);
      });
  }

  async validateRefreshToken(refreshToken: string): Promise<string> {
    try {
      const refreshTokenEntity = await this.refreshTokenRepository.validateRefreshToken(refreshToken);

      if (!refreshTokenEntity) {
        throw new BadRequestException(ERRORS_DICTIONARY.TOKEN_ERROR);
      }

      return refreshTokenEntity.id;
    } catch (error) {
      throw new BadRequestException(ERRORS_DICTIONARY.TOKEN_ERROR);
    }
  }

  async revokeRefreshToken(refreshToken: string): Promise<DeleteResult> {
    const result = await this.refreshTokenRepository.revokeRefreshToken(refreshToken);

    if (result.affected === 0) {
      throw new BadRequestException(ERRORS_DICTIONARY.TOKEN_ERROR);
    }

    return result;
  }

  async updateUser(userId: number, user: Partial<User>): Promise<UpdateResult> {
    try {
      const result = await this.userRepository.updateUser(userId, user);

      if (result.affected === 0) {
        throw new BadRequestException(ERRORS_DICTIONARY.USER_NOT_FOUND);
      }

      return result;
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async updateAccount(accountId: number, data: Partial<Account>): Promise<UpdateResult> {
    return await this.accountRepository.updateAccount(accountId, data);
  }
}
