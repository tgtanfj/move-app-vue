import { User } from '@/entities/user.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { ApiConfigService } from '@/shared/services/api-config.service';
import { RedisService } from '@/shared/services/redis/redis.service';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { BadRequestException, Injectable } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { ChannelService } from '../channel/channel.service';
import { StripeService } from '../stripe/stripe.service';
import { UserService } from '../user/user.service';
import { PaginationMetadata } from '../video/dto/response/pagination.meta';
import { BuyREPsDto } from './dto/buy-reps.dto';
import QueryPaymentHistoryDto from './dto/query-payment-history.dto';
import PaymentDto, { RepsPackageDto } from './dto/response/payment.dto';
import { WithDrawDto } from './dto/withdraw.dto';
import { PayPalService } from './paypal.service';
import { CashOutRepository } from './repositories/cashout.repository';
import { PaymentRepository } from './repositories/payment.repository';
import { RepsPackageRepository } from './repositories/reps-package.repository';

@Injectable()
export class PaymentService {
  constructor(
    private readonly repsPackageRepository: RepsPackageRepository,
    private readonly paymentRepository: PaymentRepository,
    private readonly userService: UserService,
    private readonly channelService: ChannelService,
    private readonly stripeService: StripeService,
    private readonly paypalService: PayPalService,
    private readonly redisService: RedisService,
    private readonly configService: ApiConfigService,
    private readonly cashOutRepository: CashOutRepository,
  ) {}

  async listRepsPackage() {
    try {
      return await this.repsPackageRepository.listRepsPackage();
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
        new PaginationMetadata(+total, queryPaymentHistoryDto.page, queryPaymentHistoryDto.take, totalPages),
      );
    } catch (err) {
      console.error(err);
    }
  }

  async withDraw(userId: number, withDrawDto: WithDrawDto) {
    const { email, numberOfREPs } = withDrawDto;

    const withDrawRate = this.configService.getNumber('WITHDRAW_RATE');
    const repsNeedToWithDraw = this.configService.getNumber('REPS_NEED_TO_WITHDRAW');
    const expireTimeWithdrawPerDay = this.configService.getNumber('WITHDRAW_PER_DAY_EXPIRATION_TIME_AT');
    const expireTimeWithdrawPerWeek = this.configService.getNumber('WITHDRAW_PER_WEEK_EXPIRATION_TIME_AT');

    const timesWithdrawPerDay = await this.redisService.getValue<number>(`times_withdraw_per_day_${userId}`);

    const timesWithdrawPerWeek = await this.redisService.getValue<number>(
      `times_withdraw_per_week_${userId}`,
    );

    if (timesWithdrawPerDay) {
      throw new BadRequestException(ERRORS_DICTIONARY.ONLY_ONE_WITHDRAW_PER_DAY);
    }

    if (timesWithdrawPerWeek >= 3) {
      throw new BadRequestException(ERRORS_DICTIONARY.ONLY_THREE_WITHDRAW_PER_WEEK);
    }

    const { channel } = await this.userService.findChannelByUserId(userId);

    if (
      numberOfREPs < repsNeedToWithDraw ||
      channel.numberOfREPs < repsNeedToWithDraw ||
      channel.numberOfREPs < numberOfREPs
    ) {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_ENOUGH_REPS);
    }

    if (withDrawDto.isSave) {
      this.channelService.updateEmailPayPal(channel.id, email);
    }

    const amountWithDraw = numberOfREPs * withDrawRate;
    const repsAfterWithDraw = +channel.numberOfREPs - numberOfREPs;
    const emailReceiveREPs = channel.emailPayPal ? channel.emailPayPal : email;

    try {
      this.channelService.updateREPs(channel.id, repsAfterWithDraw);

      this.paypalService.createPayout(emailReceiveREPs, amountWithDraw);

      this.cashOutRepository.createCashOutHistory(channel.id, numberOfREPs);
    } catch (error) {
      throw new BadRequestException(error);
    }

    if (!timesWithdrawPerDay) {
      await this.redisService.setValue(`times_withdraw_per_day_${userId}`, 1, expireTimeWithdrawPerDay);
    }

    if (!timesWithdrawPerWeek) {
      await this.redisService.setValue(`times_withdraw_per_week_${userId}`, 1, expireTimeWithdrawPerWeek);
    } else {
      await this.redisService.setValue(
        `times_withdraw_per_week_${userId}`,
        timesWithdrawPerWeek + 1,
        expireTimeWithdrawPerWeek,
      );
    }

    return await this.channelService.getChannelReps(userId);
  }
}
