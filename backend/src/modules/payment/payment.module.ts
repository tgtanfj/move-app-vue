import { Payment } from '@/entities/payment.entity';
import { RepsPackage } from '@/entities/reps-package.entity';
import { forwardRef, Module } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChannelModule } from '../channel/channel.module';
import { StripeModule } from '../stripe/stripe.module';
import { UserModule } from '../user/user.module';
import { PaymentController } from './payment.controller';
import { PaymentService } from './payment.service';
import { PayPalService } from './paypal.service';
import { PaymentRepository } from './repositories/payment.repository';
import { RepsPackageRepository } from './repositories/reps-package.repository';

@Module({
  imports: [
    TypeOrmModule.forFeature([RepsPackage, Payment]),
    forwardRef(() => UserModule),
    forwardRef(() => StripeModule),
    forwardRef(() => ChannelModule),
  ],
  controllers: [PaymentController],
  providers: [PaymentService, RepsPackageRepository, PaymentRepository, JwtService, PayPalService],
})
export class PaymentModule {}
