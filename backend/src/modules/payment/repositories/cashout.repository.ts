import { Cashout } from '@/entities/cashout.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeepPartial, Repository, UpdateResult } from 'typeorm';

@Injectable()
export class CashOutRepository {
  constructor(
    @InjectRepository(Cashout)
    private readonly cashOutRepository: Repository<Cashout>,
  ) {}

  async createCashOutHistory(channelId: number, numberOfREPs: number): Promise<Cashout> {
    const cashOutCreated = this.cashOutRepository.create({
      channel: {
        id: channelId,
      },
      numberOfREPs,
    });
    return await this.cashOutRepository.save(cashOutCreated);
  }

  async getAllCashOutHistory(
    startDate?: Date,
    endDate?: Date,
    search?: string,
    take?: number,
    page?: number,
    status?: string,
  ): Promise<{ items: Cashout[]; totalItems: number }> {
    const query = this.cashOutRepository
      .createQueryBuilder('cashout')
      .leftJoinAndSelect('cashout.channel', 'channel')
      .leftJoinAndSelect('channel.user', 'user');

    // Apply search filter for user's fullName and channel's name
    if (search) {
      query.andWhere('(user.email LIKE :search OR user.fullName LIKE :search OR channel.name LIKE :search)', {
        search: `%${search}%`,
      });
    }

    // Apply date range filter
    if (startDate && endDate) {
      query.andWhere('cashout.createdAt BETWEEN :startDate AND :endDate', { startDate, endDate });
    } else if (startDate) {
      query.andWhere('cashout.createdAt >= :startDate', { startDate });
    } else if (endDate) {
      query.andWhere('cashout.createdAt <= :endDate', { endDate });
    }

    // Apply transaction status filter
    if (status) {
      query.andWhere('cashout.status = :status', { status });
    }

    // Pagination
    query.skip((page - 1) * take).take(take);

    // Fetch data and count
    const [items, totalItems] = await query.getManyAndCount();

    return { items, totalItems };
  }

  async updateCashoutHistory(id: number, updateData: DeepPartial<Cashout>): Promise<UpdateResult> {
    return await this.cashOutRepository.update(id, updateData);
  }
}
