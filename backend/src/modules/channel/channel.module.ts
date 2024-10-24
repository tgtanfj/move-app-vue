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
import { EmailService } from '../email/email.service';
import { DonationModule } from '../donation/donation.module';
import { CommentModule } from '../comment/comment.module';
import { Comment } from '@/entities/comment.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Channel, Comment]),
    FollowModule,
    forwardRef(() => UserModule),
    forwardRef(() => VideoModule),
    DonationModule,
    CommentModule,
  ],
  controllers: [ChannelController],
  providers: [ChannelService, ChannelRepository, JwtService, EmailService],
  exports: [ChannelService, ChannelRepository],
})
export class ChannelModule {}
