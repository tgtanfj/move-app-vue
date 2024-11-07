import { User } from '@/entities/user.entity';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { Injectable } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { PaginationDto } from '../video/dto/request/pagination.dto';
import { PaginationMetadata } from '../video/dto/response/pagination.meta';
import { AdminRepository } from './admin.repository';
import QueryAdminPaymentHistoryDto from './dto/request/admin-query-payment-history.dto';
import RevenueRequestDto from './dto/request/revenue.dto';
import UserQueryDto from './dto/request/user-query.dto';
import VideoAdminQueryDto from './dto/request/video-admin-query.dto';
import { PaymentHistoryDto } from './dto/response/payment-history.dto';
import { RevenueDto } from './dto/response/revenue.dto';
import { CashOutRepository } from './repositories/cashout.repository';
import { PaymentRepository } from './repositories/payment.repository';
import UserRepository from './repositories/user.repository';

@Injectable()
export class AdminService {
  constructor(
    private readonly adminRepository: AdminRepository,
    private readonly cashOutRepository: CashOutRepository,
    private readonly paymentRepository: PaymentRepository,
    private readonly userRepository: UserRepository,
  ) {}

  async getRevenue({ search, take, page, sortField, sortDirection }: RevenueRequestDto) {
    let data: RevenueDto[] = [];

    // Fetch users and payments concurrently

    const [users] = await Promise.all([this.userRepository.getUsers(search)]);

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

    data.sort((a, b) => {
      const aValue = a[sortField]; // Get the value of the field to sort by
      const bValue = b[sortField];

      if (sortDirection === 'asc') {
        return aValue - bValue; // Ascending order
      } else {
        return bValue - aValue; // Descending order
      }
    });

    // Apply pagination
    const totalItems = data.length;
    const startIndex = (page - 1) * take;
    const paginatedData = data.slice(startIndex, startIndex + take);

    const totalPages = Math.ceil(totalItems / take);

    return objectResponse(paginatedData, new PaginationMetadata(totalItems, page, take, totalPages));
  }

  async getVideoAdmin(dto: VideoAdminQueryDto) {
    const [data, count] = await this.adminRepository.getVideoAdmin(dto);
    const meta: PaginationMetadata = {
      page: dto.page,
      take: dto.take,
      total: count,
      totalPages: Math.ceil(count / dto.take),
    };
    return objectResponse(data, meta);
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

  async findAllPaymentHistories({
    startDate,
    endDate,
    search,
    take,
    page,
    status,
    sortField,
    sortDirection,
  }: QueryAdminPaymentHistoryDto) {
    const { items, totalItems } = await this.paymentRepository.findPaymentHistoriesAndFilters(
      startDate,
      endDate,
      search,
      take,
      page,
      status,
      sortField,
      sortDirection,
    );

    const data = await Promise.all(
      items.map((paymentHistory) => {
        const paymentHistoryDto = plainToInstance(PaymentHistoryDto, paymentHistory, {
          excludeExtraneousValues: true,
        });

        paymentHistoryDto.email = paymentHistory.user.email;
        paymentHistoryDto.fullName = paymentHistory.user.fullName;
        paymentHistoryDto.numberOfREPs = paymentHistory.repsPackage.numberOfREPs;
        paymentHistoryDto.price = paymentHistory.repsPackage.price;

        return paymentHistoryDto;
      }),
    );

    const totalPages = Math.ceil(totalItems / take);

    return objectResponse(data, new PaginationMetadata(totalItems, page, take, totalPages));
  }

  async getAllCashOutHistories({
    startDate,
    endDate,
    search,
    take,
    page,
    status,
    sortField,
    sortDirection,
  }: QueryAdminPaymentHistoryDto) {
    const { items, totalItems } = await this.cashOutRepository.getAllCashOutHistory(
      startDate,
      endDate,
      search,
      take,
      page,
      status,
      sortField,
      sortDirection,
    );

    const totalPages = Math.ceil(totalItems / take);

    return objectResponse(items, new PaginationMetadata(totalItems, page, take, totalPages));
  }
}
