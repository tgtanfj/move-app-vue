import { TransactionStatus } from '@/entities/enums/transaction-status.enum';
import { User } from '@/entities/user.entity';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { ApiConfigService } from '@/shared/services/api-config.service';
import { RedisService } from '@/shared/services/redis/redis.service';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { BadRequestException, Injectable, InternalServerErrorException } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { I18nService } from 'nestjs-i18n';
import { ChannelService } from '../channel/channel.service';
import { NotificationService } from '../notification/notification.service';
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
    private readonly notificationService: NotificationService,
    private readonly i18n: I18nService,
  ) {}

  async listRepsPackage() {
    try {
      return await this.repsPackageRepository.listRepsPackage();
    } catch (error) {
      console.error(error);
    }
  }

  async buyREPs(user: User, buyREPsDto: BuyREPsDto) {
    const { paymentMethodId, repPackageId, save } = buyREPsDto;

    // Fetch REP package details
    const repPackage = await this.getRepPackage(repPackageId);

    // Create initial payment history record
    const paymentHistory = await this.createPaymentHistory(user.id, repPackage.id);

    try {
      // Process payment
      const charge = await this.processPayment(
        repPackage.price,
        paymentMethodId,
        user.stripeId,
        save,
        paymentHistory.id,
      );

      // Update user's REPs
      const updatedReps = repPackage.numberOfREPs + Number(user.numberOfREPs);
      await this.userService.updateREPs(user.id, updatedReps);

      // Send notification
      await this.sendPurchaseNotification(user.id, repPackage.numberOfREPs);

      return charge;
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  private async getRepPackage(repPackageId: number) {
    return await this.repsPackageRepository.findOneRepPackage(repPackageId);
  }

  private async createPaymentHistory(userId: number, repPackageId: number) {
    return await this.paymentRepository.createPaymentHistory(userId, repPackageId);
  }

  private async processPayment(
    amount: number,
    paymentMethodId: string,
    customerId: string,
    save: boolean,
    paymentHistoryId: number,
  ) {
    try {
      const charge = await this.stripeService.charge(amount, paymentMethodId, customerId, save);

      // Update payment history to completed if payment succeeds
      await this.updatePaymentHistoryStatus(paymentHistoryId, TransactionStatus.COMPLETED);
      return charge;
    } catch (error) {
      // Update payment history to failed with reason if payment fails
      await this.updatePaymentHistoryStatus(paymentHistoryId, TransactionStatus.FAILED, error.message);
      throw error;
    }
  }

  private async updatePaymentHistoryStatus(
    paymentHistoryId: number,
    status: TransactionStatus,
    reason?: string,
  ) {
    await this.paymentRepository.updatePaymentHistory(paymentHistoryId, { status, reason });
  }

  private async sendPurchaseNotification(userId: number, numberOfREPs: number) {
    const notificationData = {
      sender: 'system',
      type: NOTIFICATION_TYPE.PURCHASE,
      purchase: +numberOfREPs,
    };
    await this.notificationService.sendOneToOneNotification(userId, notificationData);
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
    const { email, numberOfREPs, isSave } = withDrawDto;

    // Step 1: Perform necessary validations
    const { channel, withDrawRate } = await this.validateAndGetChannel(userId, numberOfREPs);

    // Step 2: Save PayPal email if required
    if (isSave) await this.channelService.updateEmailPayPal(channel.id, email);

    // Step 3: Calculate amounts and update channel REPs
    const amountWithDraw = numberOfREPs * withDrawRate;
    const repsAfterWithDraw = channel.numberOfREPs - numberOfREPs;
    const emailReceiveREPs = channel.emailPayPal || email;

    // Step 4: Create cash out history
    const cashOutHistory = await this.cashOutRepository.createCashOutHistory(channel.id, numberOfREPs);

    try {
      // Step 5: Process payout with PayPal
      await this.processPayout(emailReceiveREPs, amountWithDraw, cashOutHistory.id);

      // Step 6: Update user's REPs
      await this.channelService.updateREPs(channel.id, repsAfterWithDraw);

      // Step 7: Send cashout notification
      await this.sendCashOutNotification(userId, amountWithDraw);
    } catch (error) {
      throw new InternalServerErrorException(`${this.i18n.t('exceptions.paypal.WITHDRAW_FAILED')}`);
    }

    return await this.channelService.getChannelReps(userId);
  }

  // Helper method to validate withdrawal limits
  private async validateWithdrawLimits(userId: number) {
    const timesWithdrawPerDay = await this.redisService.getValue<number>(`times_withdraw_per_day_${userId}`);
    const timesWithdrawPerWeek = await this.redisService.getValue<number>(
      `times_withdraw_per_week_${userId}`,
    );

    if (timesWithdrawPerDay) {
      throw new BadRequestException(this.i18n.t('exceptions.payment.ONLY_ONE_WITHDRAW_PER_DAY'));
    }
    if (timesWithdrawPerWeek >= 3) {
      throw new BadRequestException(this.i18n.t('exceptions.payment.ONLY_THREE_WITHDRAW_PER_WEEK'));
    }
  }

  // Helper method to validate channel and REP requirements
  private async validateAndGetChannel(userId: number, numberOfREPs: number) {
    const withDrawRate = this.configService.getNumber('WITHDRAW_RATE');
    const repsNeedToWithDraw = this.configService.getNumber('REPS_NEED_TO_WITHDRAW');
    const { channel } = await this.userService.findChannelByUserId(userId);

    if (
      numberOfREPs < repsNeedToWithDraw ||
      channel.numberOfREPs < repsNeedToWithDraw ||
      channel.numberOfREPs < numberOfREPs
    ) {
      throw new BadRequestException(this.i18n.t('exceptions.payment.NOT_ENOUGH_REPS'));
    }

    return { channel, withDrawRate };
  }

  // Helper method to process payout and update cashout history
  private async processPayout(email: string, amount: number, cashOutHistoryId: number) {
    try {
      await this.paypalService.createPayout(email, amount);
      await this.cashOutRepository.updateCashoutHistory(cashOutHistoryId, {
        status: TransactionStatus.COMPLETED,
      });
    } catch (error) {
      await this.cashOutRepository.updateCashoutHistory(cashOutHistoryId, {
        status: TransactionStatus.FAILED,
        reason: error,
      });
      throw error;
    }
  }

  // Helper method to send cash out notification
  private async sendCashOutNotification(userId: number, amount: number) {
    const notificationData = {
      sender: 'system',
      type: NOTIFICATION_TYPE.CASHOUT,
      cashout: amount,
    };
    await this.notificationService.sendOneToOneNotification(userId, notificationData);
  }

  // Helper method to update Redis limits for withdrawals
  private async updateRedisLimits(userId: number) {
    const expireTimeWithdrawPerDay = this.configService.getNumber('WITHDRAW_PER_DAY_EXPIRATION_TIME_AT');
    const expireTimeWithdrawPerWeek = this.configService.getNumber('WITHDRAW_PER_WEEK_EXPIRATION_TIME_AT');

    await this.redisService.setValue(`times_withdraw_per_day_${userId}`, 1, expireTimeWithdrawPerDay);

    const currentWeeklyCount =
      (await this.redisService.getValue<number>(`times_withdraw_per_week_${userId}`)) || 0;
    await this.redisService.setValue(
      `times_withdraw_per_week_${userId}`,
      currentWeeklyCount + 1,
      expireTimeWithdrawPerWeek,
    );
  }
}
