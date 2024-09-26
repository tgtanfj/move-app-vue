import { Module } from '@nestjs/common';
import { MailModule } from '../email/email.module';
import { StripeModule } from '../stripe/stripe.module';
import { AuthController } from './auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { EmailService } from '../email/email.service';
import { UserModule } from '../user/user.module';
import { AuthService } from './auth.service';

@Module({
  imports: [
    JwtModule.register({
      global: true,
    }),
    MailModule,
    UserModule,
    StripeModule,
  ],
  controllers: [AuthController],
  providers: [AuthService, EmailService],
})
export class AuthModule {}
