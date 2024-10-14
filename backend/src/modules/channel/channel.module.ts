import { forwardRef, Module } from '@nestjs/common';
import { ChannelService } from './channel.service';
import { ChannelController } from './channel.controller';
import { TypeORMError } from 'typeorm';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Channel } from '@/entities/channel.entity';
import { ChannelRepository } from './channel.repository';
import { FollowModule } from '../follow/follow.module';
import { JwtService } from '@nestjs/jwt';
import { UserModule } from '../user/user.module';
import { VideoModule } from '../video/video.module';
import { FollowService } from '../follow/follow.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([Channel]),
    FollowModule,
    forwardRef(() => UserModule),
    VideoModule,
  ],
  controllers: [ChannelController],
  providers: [ChannelService, ChannelRepository, JwtService],
  exports: [ChannelService, ChannelRepository],
})
export class ChannelModule {}
