import { FindManyOptions } from './../../../node_modules/typeorm/find-options/FindManyOptions.d';
import { User } from '@/entities/user.entity';
import { Injectable } from '@nestjs/common';
import { StripeService } from '../stripe/stripe.service';
import { UserService } from '../user/user.service';
import { BuyREPsDto } from './dto/buy-reps.dto';
import { PaymentRepository } from './repositories/payment.repository';
import { RepsPackageRepository } from './repositories/reps-package.repository';
import QueryPaymentHistoryDto from './dto/query-payment-history.dto';
import { plainToClass, plainToInstance } from 'class-transformer';
import PaymentDto, { RepsPackageDto } from './dto/response/payment.dto';
import { PaginationMetadata } from '../video/dto/response/pagination.meta';
import { objectResponse } from '@/shared/utils/response-metadata.function';

@Injectable()
export class PaymentService {
  constructor(
    private readonly repsPackageRepository: RepsPackageRepository,
    private readonly paymentRepository: PaymentRepository,
    private readonly userService: UserService,
    private readonly stripeService: StripeService,
  ) {}

  async listRepsPackage() {
    try {
      return this.repsPackageRepository.listRepsPackage();
    } catch (error) {
      console.error(error);
    }
  }

  async buyREPs(user: User, buyREPsDto: BuyREPsDto) {
    const { paymentMethodId, repPackageId } = buyREPsDto;

    const repPackage = await this.repsPackageRepository.findOneRepPackage(repPackageId);

    await this.stripeService.charge(repPackage.price, paymentMethodId, user.stripeId);

    const repsOfUser = repPackage.numberOfREPs + Number(user.numberOfREPs);

    await this.userService.updateREPs(user.id, repsOfUser);

    this.paymentRepository.createPaymentHistory(user.id, repPackage.id);
  }

  async getPaymentHistory(userId: number, queryPaymentHistoryDto: QueryPaymentHistoryDto) {
    try {
      const [data, total] = await this.paymentRepository
        .findPaymentHistory(
          userId,
          queryPaymentHistoryDto.startDate,
          queryPaymentHistoryDto.endDate,
          queryPaymentHistoryDto.take,
          queryPaymentHistoryDto.page,
        )
        .then(([payments, total]) => {
          const data = payments.map((payment) => {
            console.log(payment);
            const paymentDto = plainToInstance(PaymentDto, payment, { excludeExtraneousValues: true });
            paymentDto.repsPackage = plainToInstance(RepsPackageDto, payment.repsPackage, {
              excludeExtraneousValues: true,
            });
            return paymentDto;
          });

          return [data, total];
        });

      console.log(data);

      const totalPages = Math.ceil(+total / queryPaymentHistoryDto.take);

      return objectResponse(
        data,
        new PaginationMetadata(
          +total,
          queryPaymentHistoryDto.page,
          queryPaymentHistoryDto.take,
          totalPages,
        ),
      );
    } catch (err) {
      console.error(err);
    }
  }
}
