import { Payment } from '@/entities/payment.entity';
import { RepsPackage } from '@/entities/reps-package.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class PaymentRepository {
  constructor(
    @InjectRepository(RepsPackage)
    private readonly repsPackageRepository: Repository<RepsPackage>,
    @InjectRepository(Payment)
    private readonly paymentRepository: Repository<Payment>,
  ) {}

  async createPaymentHistory(totalCost: number, userId: number, repPackageId: number) {
    const paymentHistoryCreated = await this.paymentRepository.create({
      totalCost,
      user: {
        id: userId,
      },
      repsPackage: {
        id: repPackageId,
      },
    });

    return this.paymentRepository.save(paymentHistoryCreated);
  }
}
