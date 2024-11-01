import { Module } from '@nestjs/common';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';
import { UserModule } from '../user/user.module';
import { AdminRepository } from './admin.repository';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Payment } from '@/entities/payment.entity';
import { User } from '@/entities/user.entity';
import { Channel } from '@/entities/channel.entity';
import { JwtService } from '@nestjs/jwt';
import { Donation } from '@/entities/donation.entity';
import { Video } from '@/entities/video.entity';
import UserRepository from './repositories/user.repository';

@Module({
  imports: [TypeOrmModule.forFeature([Payment, User, Channel, Donation, Video]), UserModule],
  controllers: [AdminController],
  providers: [AdminService, AdminRepository, JwtService, UserRepository],
})
export class AdminModule {}
