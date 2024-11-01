import { UserModule } from '@/modules/user/user.module';
import { BullModule } from '@nestjs/bullmq';
import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config'; // Import the ConfigModule from the correct module
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import { ScheduleModule } from '@nestjs/schedule';
import { I18nMiddleware } from 'nestjs-i18n';
import { DatabaseModule } from './db/database.module';
import { AuthModule } from './modules/auth/auth.module';
import { AwsS3Module } from './modules/aws-s3/aws-s3.module';
import { CategoryModule } from './modules/category/category.module';
import { CommentReactionModule } from './modules/comment-reaction/comment-reaction.module';
import { CountryModule } from './modules/country/country.module';
import { DeeplinkModule } from './modules/deep-link/deep-link.module';
import { DonationModule } from './modules/donation/donation.module';
import { MailModule } from './modules/email/email.module';
import { FaqsModule } from './modules/faqs/faqs.module';
import { HomeModule } from './modules/home/home.module';
import { PaymentModule } from './modules/payment/payment.module';
import { SearchModule } from './modules/search/search.module';
import { StripeModule } from './modules/stripe/stripe.module';
import { ThumbnailModule } from './modules/thumbnail/thumbnail.module';
import { VideoTrendModule } from './modules/video-trend/video-trend.module';
import { VideoModule } from './modules/video/video.module';
import { WatchingVideoHistoryModule } from './modules/watching-video-history/watching-video-history.module';
import { I18nConfigModule } from './shared/configs/i18n.config';
import { GlobalException } from './shared/exceptions/global.exception';
import { ResponseInterceptor } from './shared/interceptors/response.interceptor';
import { LoggingMiddleware } from './shared/middlewares/logging.middleware';
import { ApiConfigService } from './shared/services/api-config.service';
import { RedisModule } from './shared/services/redis/redis.module';
import { NotificationModule } from './modules/notification/notification.module';
import { ViewModule } from './modules/view/view.module';
import { ChannelModule } from './modules/channel/channel.module';
import { AdminModule } from './modules/admin/admin.module';
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
    FaqsModule,
    SearchModule,
    CommentReactionModule,
    BullModule.forRootAsync({
      inject: [ApiConfigService],
      useFactory: async (apiConfig: ApiConfigService) => ({
        connection: {
          host: apiConfig.getString('REDIS_HOST'),
          port: apiConfig.getNumber('REDIS_PORT'),
          password: apiConfig.getString('REDIS_PASSWORD'),
          connectTimeout: 200000,
        },
      }),
    }),
    FaqsModule,
    HomeModule,
    ScheduleModule.forRoot(),
    VideoTrendModule,
    WatchingVideoHistoryModule,
    PaymentModule,
    DonationModule,
    NotificationModule,
    ViewModule,
    AdminModule,
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
