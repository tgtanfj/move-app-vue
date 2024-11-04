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

  async updatePaymentHistory(id: number, updateData: DeepPartial<Payment>): Promise<UpdateResult> {
    return await this.paymentRepository.update(id, updateData);
  }
}
