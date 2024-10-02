import { Module } from '@nestjs/common';
import { AwsS3Controller } from './aws-s3.controller';
import { ApiConfigService } from '@/shared/services/api-config.service';
import { GeneratorService } from '@/shared/services/generator.service';
import { AwsS3Service } from '@/shared/services/aws-s3.service';

@Module({
  controllers: [AwsS3Controller],
  providers: [ApiConfigService, GeneratorService, AwsS3Service],
  exports: [AwsS3Service],
})
export class AwsS3Module {}
