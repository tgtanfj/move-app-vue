import { Account } from '@/entities/account.entity';
import { RefreshToken } from '@/entities/refresh-token.entity';
import { User } from '@/entities/user.entity';
import { Module } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AccountRepository } from './repositories/account.repository';
import { RefreshTokenRepository } from './repositories/refresh-token.repository';
import { UserRepository } from './repositories/user.repository';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { AwsS3Module } from '../aws-s3/aws-s3.module';
import { CountryModule } from '../country/country.module';

@Module({
  imports: [TypeOrmModule.forFeature([User, Account, RefreshToken]), AwsS3Module, CountryModule],
  controllers: [UserController],
  providers: [UserService, UserRepository, JwtService, AccountRepository, RefreshTokenRepository],
  exports: [UserService, UserRepository],
})
export class UserModule {}
