import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { join } from 'path';

@Injectable()
export class ApiConfigService {
  adminInfo: any;
  constructor(private configService: ConfigService) {}

  get isDevelopment(): boolean {
    return this.nodeEnv === 'development';
  }

  get isProduction(): boolean {
    return this.nodeEnv === 'production';
  }

  get isTest(): boolean {
    return this.nodeEnv === 'test';
  }

  getNumber(key: string): number {
    const value = this.configService.get<string>(key);
    const numberValue = Number(value);

    if (isNaN(numberValue)) {
      throw new Error(`${key} environment variable is not a number`);
    }

    return numberValue;
  }

  getBoolean(key: string): boolean {
    const value = this.configService.get<string>(key);

    if (value === undefined) {
      throw new Error(`${key} environment variable is not defined`);
    }

    try {
      return Boolean(JSON.parse(value));
    } catch {
      throw new Error(`${key} environment variable is not a boolean`);
    }
  }

  getString(key: string): string {
    const value = this.configService.get<string>(key);

    if (value === undefined) {
      throw new Error(`${key} environment variable is not defined`);
    }

    return value.replace(/\\n/g, '\n');
  }

  get nodeEnv(): string {
    return this.getString('NODE_ENV');
  }

  get fallbackLanguage(): string {
    return this.getString('FALLBACK_LANGUAGE');
  }

  get postgresConfig(): TypeOrmModuleOptions {
    const entities = [join(process.cwd(), 'dist/**/*.entity.js')];

    return {
      entities,
      keepConnectionAlive: !this.isTest,
      dropSchema: this.isTest,
      type: 'postgres',
      name: 'default',
      host: this.getString('DB_HOST'),
      port: this.getNumber('DB_PORT'),
      username: this.getString('DB_USERNAME'),
      password: this.getString('DB_PASSWORD'),
      database: this.getString('DB_DATABASE'),
      synchronize: this.isDevelopment ? true : false,
      migrationsRun: true,
      migrations: [`${__dirname}/db/migrations/*{.ts,.js}`],
      migrationsTableName: 'migrations',
      ssl: this.getBoolean('DB_SSL'),
      logging: this.getBoolean('ENABLE_ORM_LOGS'),
      autoLoadEntities: true,
    };
  }

  get serverConfig() {
    return {
      port: this.configService.get<number>('PORT') || 4000,
    };
  }

  get accountSwaggerConfig() {
    return {
      name: this.getString('SWAGGER_ACCOUNT_NAME'),
      pass: this.getString('SWAGGER_ACCOUNT_PASS'),
    };
  }

  get documentationEnabled(): boolean {
    return this.getBoolean('ENABLE_DOCUMENTATION');
  }

  get awsS3Config() {
    return {
      s3AccessKeyId: this.getString('AWS_S3_ACCESS_KEY_ID'),
      s3SecretAccessKey: this.getString('AWS_S3_SECRET_ACCESS_KEY'),
      bucketRegion: this.getString('AWS_S3_BUCKET_REGION'),
      bucketName: this.getString('AWS_S3_BUCKET_NAME'),
      bucketEndpoint: this.getString('AWS_S3_BUCKET_ENDPOINT'),
    };
  }

  get vimeoConfig() {
    return {
      accessTokenVimeo: this.getString('ACCESS_TOKEN_VIMEO'),
      clientIdVimeo: this.getString('VIMEO_CLIENT_ID'),
      clientSercetClientVimeo: this.getString('VIMEO_CLIENT_SECRET'),
      apiUrlVimeo: this.getString('VIMEO_API_URL'),
    };
  }
}
