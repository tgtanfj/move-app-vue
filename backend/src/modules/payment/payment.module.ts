import { Cashout } from '@/entities/cashout.entity';
import { Payment } from '@/entities/payment.entity';
import { RepsPackage } from '@/entities/reps-package.entity';
import { RedisModule } from '@/shared/services/redis/redis.module';
import { forwardRef, Module } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChannelModule } from '../channel/channel.module';
import { StripeModule } from '../stripe/stripe.module';
import { UserModule } from '../user/user.module';
import { PaymentController } from './payment.controller';
import { PaymentService } from './payment.service';
import { PayPalService } from './paypal.service';
import { CashOutRepository } from './repositories/cashout.repository';
import { PaymentRepository } from './repositories/payment.repository';
import { RepsPackageRepository } from './repositories/reps-package.repository';
import { NotificationModule } from '../notification/notification.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([RepsPackage, Payment, Cashout]),
    forwardRef(() => UserModule),
    forwardRef(() => StripeModule),
    forwardRef(() => ChannelModule),
    RedisModule,
    NotificationModule,
  ],
  controllers: [PaymentController],
  providers: [
    PaymentService,
    RepsPackageRepository,
    PaymentRepository,
    JwtService,
    PayPalService,
    CashOutRepository,
  ],
})
export class PaymentModule {}
