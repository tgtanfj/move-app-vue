import { User } from '@/entities/user.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsOrder, FindOptionsWhere, ILike, Repository } from 'typeorm';
import UserQueryDto from '../dto/request/user-query.dto';

@Injectable()
export default class UserRepository {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async getUsers() {
    return this.userRepository.find();
  }

  async filterUsers(userQueryDto: UserQueryDto): Promise<[User[], number]> {
    const { contentSearch, gender, sortBy, isAsc, take, page } = userQueryDto;

    let searchParams: FindOptionsWhere<User>[] = [];

    if (contentSearch) {
      searchParams = [
        {
          fullName: ILike(`%${contentSearch}%`),
        },
        {
          username: ILike(`%${contentSearch}%`),
        },
        {
          email: ILike(`%${contentSearch}%`),
        },
      ];
    }

    if (gender) {
      if (searchParams.length > 0)
        searchParams = searchParams.map((params) => ({
          ...params,
          gender,
        }));

      searchParams.push({
        gender,
      });
    }

    let order: FindOptionsOrder<User> = { createdAt: 'desc' };

    if (sortBy) {
      order = {
        [sortBy]: isAsc === true ? 'asc' : 'desc',
        ...order,
      };
    }

    const skip = (page - 1) * take;

    return this.userRepository.findAndCount({
      where: searchParams,
      order,
      take,
      skip,
    });
  }
}
