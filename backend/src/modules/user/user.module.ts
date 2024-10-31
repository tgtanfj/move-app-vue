import { ChannelService } from './../channel/channel.service';
import { Account } from '@/entities/account.entity';
import { RefreshToken } from '@/entities/refresh-token.entity';
import { User } from '@/entities/user.entity';
import { forwardRef, Module } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AccountRepository } from './repositories/account.repository';
import { RefreshTokenRepository } from './repositories/refresh-token.repository';
import { UserRepository } from './repositories/user.repository';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { AwsS3Module } from '../aws-s3/aws-s3.module';
import { CountryModule } from '../country/country.module';
import { ChannelModule } from '../channel/channel.module';
import { FollowModule } from '../follow/follow.module';
import { VideoService } from '../video/video.service';
import { VideoModule } from '../video/video.module';
import { CommentModule } from '../comment/comment.module';
import { ThumbnailModule } from '../thumbnail/thumbnail.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, Account, RefreshToken]),
    forwardRef(() => ThumbnailModule),
    AwsS3Module,
    CountryModule,
    forwardRef(() => ChannelModule),
    FollowModule,
    forwardRef(() => VideoModule),
    CommentModule,
  ],
  controllers: [UserController],
  providers: [
    UserService,
    UserRepository,
    JwtService,
    ChannelService,
    AccountRepository,
    RefreshTokenRepository,
  ],
  exports: [UserService, UserRepository],
})
export class UserModule {}
