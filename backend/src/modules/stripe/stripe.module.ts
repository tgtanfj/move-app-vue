import { UserModule } from '@/modules/user/user.module';
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { StripeController } from './stripe.controller';
import { StripeService } from './stripe.service';

@Module({
  imports: [ConfigModule, UserModule],
  controllers: [StripeController],
  providers: [StripeService, JwtService],
  exports: [StripeService],
})
export class StripeModule {}
