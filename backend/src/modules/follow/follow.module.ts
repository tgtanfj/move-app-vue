import { Module } from '@nestjs/common';
import { FollowService } from './follow.service';
import { FollowController } from './follow.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Follow } from '@/entities/follow.entity';
import { FollowRepository } from './follow.repository';
import { JwtService } from '@nestjs/jwt';
import { UserModule } from '../user/user.module';

@Module({
  imports: [TypeOrmModule.forFeature([Follow]),UserModule],
  controllers: [FollowController],
  providers: [FollowService, FollowRepository,JwtService],
  exports: [FollowService],
})
export class FollowModule {}
