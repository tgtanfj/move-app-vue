import { Cashout } from '@/entities/cashout.entity';
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
import { SortField } from '../dto/request/admin-query-payment-history.dto';
import { SortDirection } from './../dto/request/admin-query-payment-history.dto';

@Injectable()
export class CashOutRepository {
  constructor(
    @InjectRepository(Cashout)
    private readonly cashOutRepository: Repository<Cashout>,
  ) {}

  async getAllCashOutHistory(
    startDate?: Date,
    endDate?: Date,
    search?: string,
    take?: number,
    page?: number,
    status?: TransactionStatus,
    sortField: SortField = SortField.CREATED_AT,
    sortDirection: SortDirection = SortDirection.DESC,
  ): Promise<{ items: Cashout[]; totalItems: number }> {
    let where: FindOptionsWhere<Cashout>[] = [];

    // relations
    const relations: FindOptionsRelations<Cashout> = {
      channel: {
        user: true,
      },
    };

    // Build the search filter

    if (search) {
      where = [
        {
          channel: [
            { name: ILike(`%${search}%`) },
            {
              user: [{ email: ILike(`%${search}%`) }, { fullName: ILike(`%${search}%`) }],
            },
          ],
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

    let order: FindOptionsOrder<Payment> = { [sortField]: sortDirection };

    // Select fields

    const select: FindOptionsSelect<Cashout> = {
      id: true,
      createdAt: true,
      numberOfREPs: true,
      status: true,
      channel: {
        name: true,
        user: {
          fullName: true,
          email: true,
        },
      },
    };

    // Fetch data with pagination
    const [items, totalItems] = await this.cashOutRepository.findAndCount({
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
