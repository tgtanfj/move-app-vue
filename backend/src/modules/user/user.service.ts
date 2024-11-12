import { Account } from '@/entities/account.entity';
import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { RefreshToken } from '@/entities/refresh-token.entity';
import { User } from '@/entities/user.entity';
import { IFile } from '@/shared/interfaces/file.interface';
import { AwsS3Service } from '@/shared/services/aws-s3.service';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { I18nService } from 'nestjs-i18n';
import { DeleteResult, FindOptionsRelations, UpdateResult } from 'typeorm';
import { SignUpEmailDto } from '../auth/dto/signup-email.dto';
import { SignUpSocialDto } from '../auth/dto/signup-social.dto';
import { ChannelRepository } from '../channel/channel.repository';
import { CountryService } from '../country/country.service';
import { UserProfile } from './dto/response/user-profile.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { AccountRepository } from './repositories/account.repository';
import { RefreshTokenRepository } from './repositories/refresh-token.repository';
import { UserRepository } from './repositories/user.repository';

@Injectable()
export class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly accountRepository: AccountRepository,
    private readonly refreshTokenRepository: RefreshTokenRepository,
    private readonly awsS3Service: AwsS3Service,
    private readonly countryService: CountryService,
    private readonly channelRepository: ChannelRepository,
    private readonly i18n: I18nService,
  ) {}

  async findOne(id: number, relations?: FindOptionsRelations<User>): Promise<User> {
    return await this.userRepository.findOne(id, relations).catch((error) => {
      throw new NotFoundException(error.message);
    });
  }

  async findAll(relations?: FindOptionsRelations<User>): Promise<User[]> {
    return await this.userRepository.findAll(relations).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async getProfile(id: number): Promise<UserProfile> {
    const relations = { country: true, state: true, channel: true };
    const foundUser = await this.userRepository.findOne(id, relations);

    const userProfile = plainToInstance(UserProfile, foundUser, { excludeExtraneousValues: true });

    userProfile.isBlueBadge = foundUser.channel ? foundUser.channel.isBlueBadge : false;
    userProfile.isPinkBadge = foundUser.channel ? foundUser.channel.isPinkBadge : false;
    userProfile.channelId = foundUser.channel ? foundUser.channel.id : null;

    return userProfile;
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
        message: this.i18n.t('exceptions.account.NOT_FOUND_ACCOUNT'),
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
    return await this.accountRepository.findOneAccount(userId);
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
        throw new BadRequestException(this.i18n.t('exceptions.authorization.TOKEN_ERROR'));
      }

      return refreshTokenEntity.id;
    } catch (error) {
      throw new BadRequestException(this.i18n.t('exceptions.authorization.TOKEN_ERROR'));
    }
  }

  async revokeRefreshToken(refreshToken: string): Promise<DeleteResult> {
    const result = await this.refreshTokenRepository.revokeRefreshToken(refreshToken);

    if (result.affected === 0) {
      throw new BadRequestException(this.i18n.t('exceptions.authorization.TOKEN_ERROR'));
    }

    return result;
  }

  async updateUser(userId: number, dto: UpdateUserDto, file?: IFile): Promise<UpdateResult> {
    try {
      const dataUpdate = dto;

      if (dto.username) {
        const user = await this.userRepository.findOne(userId);
        if (user.username != dto.username) {
          const userExists = await this.userRepository.findOneByUserName(dto.username);
          if (userExists) {
            throw new BadRequestException(
              `The username '${dto.username}' has been taken. Try another username.`,
            );
          }
          const channel = await this.channelRepository.getChannelByUserId(userId);
          if (channel) {
            await this.channelRepository.editChannel(channel.id, { name: dto.username });
          }
        }
      }

      if (file) {
        const image = await this.awsS3Service.uploadAvatar(file);
        const channel = await this.channelRepository.getChannelByUserId(userId);
        if (channel) {
          await this.channelRepository.editChannel(channel.id, { image: image });
        }
        dto.avatar = image;
      }

      if (dto.countryId && dto.stateId) {
        const statesOfCountry = await this.countryService.getStatesOfCountry(dto.countryId);
        const isValidState = statesOfCountry.find((state) => state.id == dto.stateId);

        if (!isValidState) {
          throw new BadRequestException(this.i18n.t('exceptions.user.INVALID_STATE'));
        }
      }

      const result = await this.userRepository.updateUser(userId, dataUpdate);

      if (result.affected === 0) {
        throw new BadRequestException(this.i18n.t('exceptions.users.USER_NOT_FOUND'));
      }

      return result;
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async updateAccount(accountId: number, data: Partial<Account>): Promise<UpdateResult> {
    return await this.accountRepository.updateAccount(accountId, data);
  }

  async updateREPs(userId: number, numberOfREPs: number) {
    return this.userRepository.updateREPs(userId, numberOfREPs);
  }

  async findChannelByUserId(userId: number): Promise<User> {
    return await this.userRepository.findOne(userId, { channel: true }).catch((error) => {
      console.error(error);
      throw new BadRequestException(error);
    });
  }

  async updateToken(userId: number, token?: string) {
    const data = token ? token : null;
    return this.userRepository.updateToken(userId, data);
  }
}
