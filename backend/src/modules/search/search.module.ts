import { Module } from '@nestjs/common';
import { SearchService } from './search.service';
import { SearchController } from './search.controller';
import { CategoryModule } from '../category/category.module';
import { ChannelModule } from '../channel/channel.module';
import { VideoModule } from '../video/video.module';

@Module({
  imports: [CategoryModule, ChannelModule, VideoModule],
  controllers: [SearchController],
  providers: [SearchService],
})
export class SearchModule {}
