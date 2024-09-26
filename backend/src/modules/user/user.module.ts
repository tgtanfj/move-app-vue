import { User } from '@/entities/user.entity';
import { Module } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserController } from './user.controller';
import { UserRepository } from './user.repository';
import { UserService } from './user.service';
import { Account } from '@/entities/account.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, Account])],
  controllers: [UserController],
  providers: [UserService, UserRepository, JwtService],
  exports: [UserService, UserRepository],
})
export class UserModule {}
