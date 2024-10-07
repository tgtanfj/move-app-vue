import { Injectable } from '@nestjs/common';
import { CategoryService } from '../category/category.service';
import { ChannelService } from '../channel/channel.service';
import { VideoService } from '../video/video.service';

@Injectable()
export class SearchService {
  // constructor(
  //   private readonly categoriesService: CategoryService,
  //   private readonly channelsService: ChannelService,
  //   private readonly videosService: VideoService,
  // ) {}
  // async searchAll(query: string) {
  //   const categories = await this.categoriesService.searchCategories(query);
  //   const channels = await this.channelsService.searchChannels(query);
  //   const videos = await this.videosService.searchVideos(query);
  // return { categories, channels, videos };
  // }
}
