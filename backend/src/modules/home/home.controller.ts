import { Controller, Get } from '@nestjs/common';
import { HomeService } from './home.service';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('home')
@Controller('home')
export class HomeController {
  constructor(private readonly homeService: HomeService) {}

  @Get('/videos-trend')
  async getVideoHotTrend() {
    return await this.homeService.getListVideoTrend();
  }
}
