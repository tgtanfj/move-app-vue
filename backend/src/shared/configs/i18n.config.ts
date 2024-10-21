import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AcceptLanguageResolver, I18nModule } from 'nestjs-i18n';
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
      resolvers: [new AcceptLanguageResolver()],
      inject: [ConfigService],
    }),
  ],
})
export class I18nConfigModule {}
