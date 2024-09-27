import { Account } from '@/entities/account.entity';
import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { RefreshToken } from '@/entities/refresh-token.entity';
import { User } from '@/entities/user.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { plainToInstance } from 'class-transformer';
import { DeleteResult, Repository } from 'typeorm';
import { SignUpEmailDto } from '../auth/dto/signup-email.dto';
import { SignUpSocialDto } from '../auth/dto/signup-social.dto';
import { UserProfile } from './dto/response/user-profile.dto';
import { UserRepository } from './user.repository';

@Injectable()
export class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    @InjectRepository(Account) private accountRepository: Repository<Account>,
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
    return this.userRepository.createAccount(userId, password).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }
  async getOneUserByEmailOrThrow(email: string): Promise<User> {
    return await this.userRepository.getOneUserByEmailOrThrow(email);
  }
  async updatePassword(newPassword: string, userId: number) {
    await this.findOne(userId);
    const foundAccount = await this.accountRepository.findOne({
      where: {
        user: {
          id: userId,
        },
      },
    });
    if (!foundAccount) {
      throw new BadRequestException({
        message: ERRORS_DICTIONARY.NOT_FOUND_ACCOUNT,
      });
    }

    foundAccount.oldPassword = foundAccount.password;
    foundAccount.password = newPassword;
    return await this.accountRepository.save(foundAccount);
  }
  async createAccountSocial(userId: number, type: TypeAccount): Promise<Account> {
    return this.userRepository.createAccountSocial(userId, type).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async findOneAccount(userId: number): Promise<Account> {
    return this.userRepository.findOneAccount(userId).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async saveRefreshToken(userId: number, deviceInfo: any, refreshToken: string): Promise<RefreshToken> {
    return await this.userRepository.saveFreshToken(userId, deviceInfo, refreshToken).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async validateRefreshToken(refreshToken: string): Promise<string> {
    try {
      const refreshTokenEntity = await this.userRepository.validateRefreshToken(refreshToken);

      if (!refreshTokenEntity) {
        throw new BadRequestException(ERRORS_DICTIONARY.TOKEN_ERROR);
      }

      return refreshTokenEntity.id;
    } catch (error) {
      throw new BadRequestException(ERRORS_DICTIONARY.TOKEN_ERROR);
    }
  }

  async revokeRefreshToken(refreshToken: string): Promise<DeleteResult> {
    const result = await this.userRepository.revokeRefreshToken(refreshToken);

    if (result.affected === 0) {
      throw new BadRequestException(ERRORS_DICTIONARY.TOKEN_ERROR);
    }

    return result;
  }
}
