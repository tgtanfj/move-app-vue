import { Module } from '@nestjs/common';
import { ChannelService } from './channel.service';
import { ChannelController } from './channel.controller';
import { TypeORMError } from 'typeorm';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Channel } from '@/entities/channel.entity';
import { ChannelRepository } from './channel.repository';

@Module({
  imports: [TypeOrmModule.forFeature([Channel])],
  controllers: [ChannelController],
  providers: [ChannelService, ChannelRepository],
  exports: [ChannelService, ChannelRepository],
})
export class ChannelModule {}