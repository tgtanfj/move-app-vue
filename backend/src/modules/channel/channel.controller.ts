import { Public } from '@/shared/decorators/public.decorator';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { Body, Controller, Get, Param, ParseIntPipe, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { ChannelService } from './channel.service';
import { EditChannelDto } from './dto/request/edit-channel.dto';
import { FilterWorkoutLevel, SortBy } from './dto/request/filter-video-channel.dto';
import { SetUpPayPalDto } from './dto/request/set-up-paypal.dto';
import { ChannelSettingDto } from './dto/response/channel-setting.dto';

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
}
