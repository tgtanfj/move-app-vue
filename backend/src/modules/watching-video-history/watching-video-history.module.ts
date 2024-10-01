import { Module } from '@nestjs/common';
import { WatchingVideoHistoryService } from './watching-video-history.service';
import { WatchingVideoHistoryController } from './watching-video-history.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WatchingVideoHistory } from '@/entities/watching-video-history.entity';
import { WatchingVideoHistoryRepository } from './watching-video-history.repository';

@Module({
  imports: [TypeOrmModule.forFeature([WatchingVideoHistory])],
  controllers: [WatchingVideoHistoryController],
  providers: [WatchingVideoHistoryService, WatchingVideoHistoryRepository],
  exports: [WatchingVideoHistoryService, WatchingVideoHistoryRepository]
})
export class WatchingVideoHistoryModule {}
