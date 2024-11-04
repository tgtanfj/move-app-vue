import { User } from '@/entities/user.entity';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { Injectable } from '@nestjs/common';
import { PaginationDto } from '../video/dto/request/pagination.dto';
import { PaginationMetadata } from '../video/dto/response/pagination.meta';
import { AdminRepository } from './admin.repository';
import QueryAdminPaymentHistoryDto from './dto/request/admin-query-payment-history.dto';
import UserQueryDto from './dto/request/user-query.dto';
import VideoAdminQueryDto from './dto/request/video-admin-query.dto';
import { RevenueDto } from './dto/response/revenue.dto';
import { CashOutRepository } from './repositories/cashout.repository';
import { PaymentRepository } from './repositories/payment.repository';

@Injectable()
export class AdminService {
  constructor(
    private readonly adminRepository: AdminRepository,
    private readonly cashOutRepository: CashOutRepository,
    private readonly paymentRepository: PaymentRepository,
  ) {}

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

    const totalPages = Math.ceil(totalItems / take);

    return objectResponse(items, new PaginationMetadata(totalItems, page, take, totalPages));
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
