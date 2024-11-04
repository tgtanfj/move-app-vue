import { Cashout } from '@/entities/cashout.entity';
import { Channel } from '@/entities/channel.entity';
import { Donation } from '@/entities/donation.entity';
import { Payment } from '@/entities/payment.entity';
import { User } from '@/entities/user.entity';
import { Video } from '@/entities/video.entity';
import { Module } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserModule } from '../user/user.module';
import { AdminController } from './admin.controller';
import { AdminRepository } from './admin.repository';
import { AdminService } from './admin.service';
import { CashOutRepository } from './repositories/cashout.repository';
import { PaymentRepository } from './repositories/payment.repository';
import UserRepository from './repositories/user.repository';

@Module({
  imports: [TypeOrmModule.forFeature([Payment, User, Channel, Donation, Cashout, Video]), UserModule],
  controllers: [AdminController],
  providers: [
    AdminService,
    AdminRepository,
    JwtService,
    UserRepository,
    CashOutRepository,
    PaymentRepository,
  ],
})
export class AdminModule {}
