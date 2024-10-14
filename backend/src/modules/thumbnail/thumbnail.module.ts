import { forwardRef, Module } from '@nestjs/common';
import { ThumbnailService } from './thumbnail.service';
import { ThumbnailController } from './thumbnail.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Thumbnail } from '@/entities/thumbnail.entity';
import { AwsS3Service } from '@/shared/services/aws-s3.service';
import { UserModule } from '../user/user.module';
import { JwtService } from '@nestjs/jwt';
import { ThumbnailRepository } from './thumbnail.repository';
import { GeneratorService } from '@/shared/services/generator.service';

@Module({
  imports: [TypeOrmModule.forFeature([Thumbnail]), forwardRef(() => UserModule)],
  controllers: [ThumbnailController],
  providers: [ThumbnailService, AwsS3Service, JwtService, ThumbnailRepository, GeneratorService],
  exports: [ThumbnailService, ThumbnailRepository],
})
export class ThumbnailModule {}
