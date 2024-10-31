import { Payment } from '@/entities/payment.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, DeepPartial, LessThanOrEqual, MoreThanOrEqual, Repository, UpdateResult } from 'typeorm';

@Injectable()
export class PaymentRepository {
  constructor(
    @InjectRepository(Payment)
    private readonly paymentRepository: Repository<Payment>,
  ) {}

  async createPaymentHistory(userId: number, repPackageId: number): Promise<Payment> {
    const paymentHistoryCreated = await this.paymentRepository.create({
      user: {
        id: userId,
      },
      repsPackage: {
        id: repPackageId,
      },
    });

    return await this.paymentRepository.save(paymentHistoryCreated);
  }

  async findPaymentHistory(
    userId: number,
    startDate?: Date | null,
    endDate?: Date | null,
    take: number = 10,
    page: number = 1,
  ): Promise<[Payment[], number]> {
    return await this.paymentRepository.findAndCount({
      where: {
        user: { id: userId },
        createdAt:
          startDate && endDate
            ? Between(startDate, endDate)
            : startDate
              ? MoreThanOrEqual(startDate)
              : endDate
                ? LessThanOrEqual(endDate)
                : undefined,
      },
      order: {
        createdAt: 'DESC',
      },
      relations: {
        repsPackage: true,
      },
      take: take,
      skip: (page - 1) * take,
    });
  }

  async findPaymentHistoriesAndFilters(
    startDate?: Date,
    endDate?: Date,
    search?: string,
    take?: number,
    page?: number,
    status?: string,
  ): Promise<{ items: Payment[]; totalItems: number }> {
    const query = this.paymentRepository
      .createQueryBuilder('payment')
      .leftJoinAndSelect('payment.user', 'user')
      .leftJoinAndSelect('payment.repsPackage', 'repsPackage');

    // Apply search filter for user's fullName and channel's name
    if (search) {
      query.andWhere('(user.email LIKE :search OR user.fullName LIKE :search)', { search: `%${search}%` });
    }

    // Apply date range filter
    if (startDate && endDate) {
      query.andWhere('payment.createdAt BETWEEN :startDate AND :endDate', { startDate, endDate });
    } else if (startDate) {
      query.andWhere('payment.createdAt >= :startDate', { startDate });
    } else if (endDate) {
      query.andWhere('payment.createdAt <= :endDate', { endDate });
    }

    // Apply transaction status filter
    if (status) {
      query.andWhere('payment.status = :status', { status });
    }

    // Pagination
    query.skip((page - 1) * take).take(take);

    // Fetch data and count
    const [items, totalItems] = await query.getManyAndCount();

    return { items, totalItems };
  }

  async updatePaymentHistory(id: number, updateData: DeepPartial<Payment>): Promise<UpdateResult> {
    return await this.paymentRepository.update(id, updateData);
  }
}
