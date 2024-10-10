import { Controller, Get } from '@nestjs/common';
import { HomeService } from './home.service';

@Controller('home')
export class HomeController {
  constructor(private readonly homeService: HomeService) {}

  @Get('/videos-trend')
  async getVideoHotTrend() {
    return await this.homeService.getListVideoTrend();
  }
}
