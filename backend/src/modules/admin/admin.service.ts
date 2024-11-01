import { Injectable } from '@nestjs/common';
import { AdminRepository } from './admin.repository';
import { RevenueDto } from './dto/response/revenue.dto';
import { PaginationDto } from '../video/dto/request/pagination.dto';
import { SortVideoAdmin } from './dto/request/sort-video-admin.dto';
import { DurationType } from '@/entities/enums/durationType.enum';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import UserQueryDto from './dto/request/user-query.dto';
import { User } from '@/entities/user.entity';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { PaginationMetadata } from '../video/dto/response/pagination.meta';

@Injectable()
export class AdminService {
  constructor(private readonly adminRepository: AdminRepository) {}

  async getRevenue() {
    let data: RevenueDto[] = [];

    // Fetch users and payments concurrently
    const [users] = await Promise.all([this.adminRepository.getUsers()]);

    for (const user of users) {
      const { id, fullName, email } = user;

      const row: RevenueDto = { id, fullName, email };

      const [channel, totalTopUp, totalDonations] = await Promise.all([
        this.adminRepository.getChannelByUserId(id),
        this.adminRepository.getSumTopUp(id),
        this.adminRepository.getSumDonation(id),
      ]);

      row.totalEarnings = +channel?.totalREPs || 0;
      row.totalTopUp = +totalTopUp || 0;
      row.totalDonations = +totalDonations || 0;

      if (row.totalTopUp != 0 || row.totalDonations != 0 || row.totalEarnings != 0) data.push(row);
    }

    return data;
  }

  async getVideoAdmin(
    query: string,
    workoutLevel: WorkoutLevel,
    duration: DurationType,
    sortBy: SortVideoAdmin,
    paginationDto: PaginationDto,
  ) {
    const data = await this.adminRepository.getVideoAdmin(
      query,
      workoutLevel,
      duration,
      sortBy,
      paginationDto,
    );
    return data;
  }

  async getUsers(userQueryDto: UserQueryDto): Promise<{ data: User[]; meta: PaginationDto }> {
    const [data, count] = await this.adminRepository.filterUsers(userQueryDto);
    const meta: PaginationMetadata = {
      page: userQueryDto.page,
      take: userQueryDto.take,
      total: count,
      totalPages: Math.ceil(count / userQueryDto.take),
    };
    return objectResponse(data, meta);
  }
}
