import { Module } from '@nestjs/common';
import { MailModule } from '../email/email.module';
import { StripeModule } from '../stripe/stripe.module';
import { UserModule } from '../user/user.module';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

@Module({
  imports: [MailModule, StripeModule, UserModule],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
