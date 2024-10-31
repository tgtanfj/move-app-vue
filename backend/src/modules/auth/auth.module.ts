import { LocalStrategy } from '@/shared/guards/strategies/local.strategy';
import { RedisModule } from '@/shared/services/redis/redis.module';
import { PublicIpAddressService } from '@/shared/utils/publicIpAddressService';
import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { MailModule } from '../email/email.module';
import { EmailService } from '../email/email.service';
import { StripeModule } from '../stripe/stripe.module';
import { UserModule } from '../user/user.module';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { NotificationModule } from '../notification/notification.module';

@Module({
  imports: [
    MailModule,
    StripeModule,
    UserModule,
    MailModule,
    PassportModule,
    RedisModule,
    NotificationModule,
    JwtModule.registerAsync({
      useFactory: (configService: ConfigService) => ({
        secret: configService.get('JWT_SECRET'),
        signOptions: { expiresIn: configService.get('JWT_EXPIRES_IN') },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, LocalStrategy, PublicIpAddressService, EmailService],
})
export class AuthModule {}
