import { User } from '@/entities/user.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Equal, FindOptionsRelations, Repository, UpdateResult } from 'typeorm';
import { SignUpEmailDto } from '../../auth/dto/signup-email.dto';
import { SignUpSocialDto } from '../../auth/dto/signup-social.dto';
import { UpdateUserDto } from '../dto/update-user.dto';

@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
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

  async findAll(relations?: FindOptionsRelations<User>): Promise<User[]> {
    return this.userRepository.find({
      relations,
    });
  }

  async findOneByEmail(email: string): Promise<User> {
    const foundUser = await this.userRepository.findOneBy({
      email,
    });

    return foundUser;
  }

  async findOneByUserName(username: string): Promise<User> {
    const foundUser = await this.userRepository.findOneBy({
      username,
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
    const { email, stripeId, username } = signUpEmailDto;

    return await this.userRepository.save({ email, stripeId, username });
  }

  async createUserBySocial(signUpDto: SignUpSocialDto): Promise<User> {
    return await this.userRepository.save({ ...signUpDto, isActive: true });
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

  async updateUserByEmail(email: string, user: Partial<User>): Promise<UpdateResult> {
    return await this.userRepository.update(email, user);
  }

  async updateUser(userId: number, dto: UpdateUserDto): Promise<UpdateResult> {
    const { countryId, stateId, ...dataUpdated } = dto;

    if (countryId) dataUpdated['country'] = { id: Number(countryId) };

    if (stateId) dataUpdated['state'] = { id: Number(stateId) };

    return await this.userRepository.update(userId, dataUpdated);
  }

  async updateREPs(userId: number, numberOfREPs: number): Promise<UpdateResult> {
    return this.userRepository.update(userId, {
      numberOfREPs,
    });
  }
}
