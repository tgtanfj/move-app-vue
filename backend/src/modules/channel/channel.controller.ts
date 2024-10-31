import { Public } from '@/shared/decorators/public.decorator';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { Body, Controller, Get, Param, ParseIntPipe, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { ChannelService } from './channel.service';
import { EditChannelDto } from './dto/request/edit-channel.dto';
import { FilterWorkoutLevel, SortBy } from './dto/request/filter-video-channel.dto';
import { SetUpPayPalDto } from './dto/request/set-up-paypal.dto';
import { ChannelSettingDto } from './dto/response/channel-setting.dto';
import { VideosAnalyticDTO } from '../video/dto/request/videos-analytic.dto';

@ApiTags('channel')
@ApiBearerAuth('jwt')
@Controller('channel')
export class ChannelController {
  constructor(private readonly channelService: ChannelService) {}

  @ApiQuery({ name: 'workout-level', enum: FilterWorkoutLevel, required: false })
  @ApiQuery({ name: 'categoryId', type: Number, required: false })
  @ApiQuery({ name: 'sort-by', enum: SortBy, required: false })
  @ApiQuery({ name: 'take', type: Number, required: false })
  @ApiQuery({ name: 'page', type: Number, required: false })
  @Public()
  @UseGuards(JwtAuthGuard)
  @Get('/:id/videos')
  async channelVideos(
    @Param('id', new ParseIntPipe())
    channelId: number,
    @Query('workout-level')
    workoutLevel: FilterWorkoutLevel = FilterWorkoutLevel.ALL_LEVEL,
    @Query('sort-by')
    sortBy: SortBy = SortBy.MOST_RECENT,
    @Query('categoryId')
    categoryId: number = undefined,
    @Query('take')
    take: number = 6,
    @Query('page')
    page: number = 1,
    @User()
    user?,
  ) {
    return await this.channelService.getChannelVideos(
      channelId,
      user ? user.id : undefined,
      workoutLevel,
      categoryId,
      sortBy,
      {
        take,
        page,
      },
    );
  }

  @Get('/:id/about')
  @Public()
  @UseGuards(JwtAuthGuard)
  async channelProfilePrivate(
    @Param('id', new ParseIntPipe())
    channelId: number,
    @User() user?,
  ) {
    return {
      data: await this.channelService.getChannelProfile(channelId, user ? user.id : undefined),
    };
  }

  @Get('/setting')
  @UseGuards(JwtAuthGuard)
  async getChannelSetting(@User() user?): Promise<ChannelSettingDto> {
    return await this.channelService.getChannelSetting(user.id);
  }

  @Get('/get-reps')
  @UseGuards(JwtAuthGuard)
  async getReps(@User() user?) {
    return await this.channelService.getChannelReps(user.id);
  }

  @Get('')
  @UseGuards(JwtAuthGuard)
  async create(@User() user?) {
    const dto = { name: user.username, image: user.avatar ?? undefined };
    return await this.channelService.createChannel(user.id, dto);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  async editChannel(@Param('id') id: number, @Body() dto: EditChannelDto) {
    return await this.channelService.editChannel(id, dto);
  }

  @Post('set-up-paypal')
  @UseGuards(JwtAuthGuard)
  async setUpPayPal(@User() user, @Body() setUpPayPalDto: SetUpPayPalDto) {
    return await this.channelService.setUpPayPal(user.id, setUpPayPalDto.emailPayPal);
  }

  @Get('overview')
  @UseGuards(JwtAuthGuard)
  async overviewChannel(@User() user) {
    return await this.channelService.overViewAnalytic(user.id);
  }

  @Get('get-all-comments')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Get all comments with filtering, sorting, and pagination options' })
  @ApiQuery({
    name: 'filter',
    required: false,
    description: 'Filter comments. Options: "all", "unresponded", "responded". Default is "all".',
    schema: {
      type: 'string',
      default: 'all',
      enum: ['all', 'unresponded', 'responded'],
    },
  })
  @ApiQuery({
    name: 'sort',
    required: false,
    description: 'Sort comments by "createdAt" or "receivedReps". Default is "createdAt".',
    schema: {
      type: 'string',
      default: 'createdAt',
      enum: ['createdAt', 'receivedReps'],
    },
  })
  @ApiQuery({
    name: 'page',
    required: false,
    description: 'Page number, default is 1',
    schema: {
      type: 'number',
      default: 1,
    },
  })
  @ApiQuery({
    name: 'pageSize',
    required: false,
    description: 'Number of items per page, default is 5',
    schema: {
      type: 'number',
      default: 5,
    },
  })
  async getAllComments(
    @User() user,
    @Query('filter') filter: string = 'all',
    @Query('sort') sort: string = 'createdAt',
    @Query('page') page: number = 1,
    @Query('pageSize') pageSize: number = 5,
  ) {
    const { data, totalItemCount, totalPages, itemFrom, itemTo } = await this.channelService.getAllComments(
      user.id,
      filter,
      sort,
      page,
      pageSize,
    );

    return {
      data,
      meta: {
        totalItemCount,
        totalPages,
        itemFrom,
        itemTo,
      },
    };
  }

  @ApiOperation({ summary: 'get video analytics' })
  @Get('video-analytics')
  @UseGuards(JwtAuthGuard)
  async videosAnalytics(@User() user, @Query() dto: VideosAnalyticDTO) {
    const asc: boolean = dto.asc === 'true';
    return await this.channelService.videoAnalytics(user.id, dto.option, dto.sortBy, dto.page, dto.take, asc);
  }
}
