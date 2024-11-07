import { TransactionStatus } from '@/entities/enums/transaction-status.enum';
import { Payment } from '@/entities/payment.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import {
  Between,
  FindOptionsOrder,
  FindOptionsRelations,
  FindOptionsSelect,
  FindOptionsWhere,
  ILike,
  Repository,
} from 'typeorm';
import { SortDirection, SortField } from '../dto/request/admin-query-payment-history.dto';

@Injectable()
export class PaymentRepository {
  constructor(
    @InjectRepository(Payment)
    private readonly paymentRepository: Repository<Payment>,
  ) {}

  async findPaymentHistoriesAndFilters(
    startDate?: Date,
    endDate?: Date,
    search?: string,
    take?: number,
    page?: number,
    status?: TransactionStatus,
    sortField: SortField = SortField.CREATED_AT,
    sortDirection: SortDirection = SortDirection.DESC,
  ): Promise<{ items: Payment[]; totalItems: number }> {
    let where: FindOptionsWhere<Payment>[] = [];

    // relations
    const relations: FindOptionsRelations<Payment> = {
      user: true,
      repsPackage: true,
    };

    // Build the search filter

    if (search) {
      where = [
        {
          user: [{ email: ILike(`%${search}%`) }, { fullName: ILike(`%${search}%`) }],
        },
      ];
    }

    // Date range filter

    if (startDate && endDate) {
      if (where.length > 0) {
        where = where.map((params) => ({
          ...params,
          createdAt: Between(startDate, endDate),
        }));
      } else {
        where.push({
          createdAt: Between(startDate, endDate),
        });
      }
    }

    // Transaction status filter

    if (status) {
      if (where.length > 0) {
        where = where.map((params) => ({
          ...params,
          status,
        }));
      } else {
        where.push({
          status,
        });
      }
    }

    // Sort by

    let order: FindOptionsOrder<Payment> = {};

    if (sortField === 'numberOfREPs') {
      order = {
        repsPackage: {
          numberOfREPs: sortDirection,
        },
      };
    } else if (sortField === 'price') {
      order = {
        repsPackage: {
          price: sortDirection,
        },
      };
    } else {
      order = { [sortField]: sortDirection };
    }

    // Select fields

    const select: FindOptionsSelect<Payment> = {
      id: true,
      createdAt: true,
      repsPackage: {
        numberOfREPs: true,
        price: true,
      },
      status: true,
      user: {
        fullName: true,
        email: true,
      },
    };

    // Fetch data with pagination
    const [items, totalItems] = await this.paymentRepository.findAndCount({
      where,
      relations,
      skip: (page - 1) * take,
      take,
      select,
      order,
    });

    return { items, totalItems };
  }
}
