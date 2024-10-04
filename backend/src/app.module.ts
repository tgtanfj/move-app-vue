import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config'; // Import the ConfigModule from the correct module
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { DatabaseModule } from './db/database.module';
import { UserModule } from '@/modules/user/user.module';
import { JwtService } from '@nestjs/jwt';
import { I18nMiddleware } from 'nestjs-i18n';
import { AuthModule } from './modules/auth/auth.module';
import { AwsS3Module } from './modules/aws-s3/aws-s3.module';
import { CategoryModule } from './modules/category/category.module';
import { CountryModule } from './modules/country/country.module';
import { DeeplinkModule } from './modules/deep-link/deep-link.module';
import { MailModule } from './modules/email/email.module';
import { StripeModule } from './modules/stripe/stripe.module';
import { ThumbnailModule } from './modules/thumbnail/thumbnail.module';
import { VideoModule } from './modules/video/video.module';
import { I18nConfigModule } from './shared/configs/i18n.config';
import { GlobalException } from './shared/exceptions/global.exception';
import { ResponseInterceptor } from './shared/interceptors/response.interceptor';
import { LoggingMiddleware } from './shared/middlewares/logging.middleware';
import { RedisModule } from './shared/services/redis/redis.module';
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: process.env.NODE_ENV === 'development' ? '.env.dev' : '.env',
      cache: true,
      expandVariables: true,
    }),
    StripeModule,
    DatabaseModule,
    RedisModule,
    I18nConfigModule,
    MailModule,
    CountryModule,
    UserModule,
    AuthModule,
    DeeplinkModule,
    AwsS3Module,
    VideoModule,
    CategoryModule,
    ThumbnailModule,
  ],
  providers: [
    {
      provide: APP_FILTER,
      useClass: GlobalException,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: ResponseInterceptor,
    },
    JwtService,
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggingMiddleware, I18nMiddleware).forRoutes('*');
  }
}
