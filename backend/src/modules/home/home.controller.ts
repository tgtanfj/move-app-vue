import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { HomeService } from './home.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/shared/guards';
import { User } from '@/shared/decorators/user.decorator';
import { PaginationDto } from '../video/dto/request/pagination.dto';

@ApiTags('home')
@Controller('home')
export class HomeController {
  constructor(private readonly homeService: HomeService) {}

  @Get('/videos-trend')
  async getVideoHotTrend() {
    return await this.homeService.getListVideoTrend();
  }

  @Get('/top-categories')
  async getTopCategories() {
    return await this.homeService.getCategories(6);
  }

  @Get('/categories')
  async getAllCategories() {
    return await this.homeService.getCategories();
  }
  @ApiBearerAuth('jwt')
  @UseGuards(JwtAuthGuard)
  @Get('/categories/:id')
  async getVideosOfCategory(
    @User() user,
    @Param('id') categoryId: number,
    @Query('page') page: number = 1,
    @Query('take') take: number = 12,
  ) {
    const newDto = new PaginationDto(take, page);
    return await this.homeService.specificCategory(user.id, categoryId, newDto);
  }

  @Get('categories-no-login/:id')
  async getCategoryWithOutLogin(
    @Param('id') categoryId: number,
    @Query('page') page: number = 1,
    @Query('take') take: number = 12,
  ) {
    const newDto = new PaginationDto(take, page);
    return this.homeService.specificCategoryWithOutLogin(categoryId, newDto);
  }

  @ApiBearerAuth('jwt')
  @UseGuards(JwtAuthGuard)
  @Get('you-may-like')
  async youMayLike(@User() user) {
    // return await this.homeService.topView7Day()
    // return await this.homeService.recentWatchedVideo(user.id);
    return await this.homeService.youMayLike(user.id);
  }

  @Get('you-may-like-no-login')
  async youMayLikeNoLogin() {
    return this.homeService.youMayLikeWithOutLogin();
  }

  @ApiBearerAuth('jwt')
  @UseGuards(JwtAuthGuard)
  @Get('get-channels')
  async getChannels(@User() user) {
    return await this.homeService.getChannelsUserFollow(user.id);
  }
}
