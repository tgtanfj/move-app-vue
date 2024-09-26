import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  AcceptLanguageResolver,
  CookieResolver,
  HeaderResolver,
  I18nModule,
  QueryResolver,
} from 'nestjs-i18n';
import { join } from 'path';

@Module({
  imports: [
    I18nModule.forRootAsync({
      useFactory: (configService: ConfigService) => ({
        fallbackLanguage: 'en',
        loaderOptions: {
          path: join(__dirname, '../locales/'),
          watch: true,
        },
      }),
      // resolvers: [
      //   { use: QueryResolver, options: ['lang'] },
      //   new HeaderResolver(['x-custom-lang']),
      //   new CookieResolver(),
      //   AcceptLanguageResolver,
      // ],
      inject: [ConfigService],
    }),
  ],
})
export class I18nConfigModule {}
