import { Controller, Get, Param, ParseEnumPipe, ParseIntPipe, Query, UseGuards } from '@nestjs/common';
import { ChannelService } from './channel.service';
import { query } from 'express';
import { FilterVideoChannelDto, FilterWorkoutLevel, SortBy } from './dto/request/filter-video-channel.dto';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/shared/guards';
import { User } from '@/shared/decorators/user.decorator';

@ApiTags('channel')
@ApiBearerAuth('jwt')
@Controller('channel')
export class ChannelController {
  constructor(private readonly channelService: ChannelService) {}

  @ApiQuery({ name: 'workout-level', enum: FilterWorkoutLevel, required: false })
  @ApiQuery({ name: 'categoryId', type: String, required: false })
  @ApiQuery({ name: 'sort-by', enum: SortBy, required: false })
  @Get('/:id/videos')
  @UseGuards(JwtAuthGuard)
  async channelVideos(
    @Param('id', new ParseIntPipe())
    channelId: number,
    @Query('workout-level')
    workoutLevel: FilterWorkoutLevel = FilterWorkoutLevel.ALL_LEVEL,
    @Query('sort-by')
    sortBy: SortBy = SortBy.MOST_RECENT,
    @Query('categoryId')
    categoryId: string = undefined,
    @User()
    user,
  ) {
    const parsedCategoryId = categoryId ? parseInt(categoryId, 10) : null;

    return (
      await this.channelService.getChannelVideos(channelId, user.id, workoutLevel, parsedCategoryId, sortBy)
    ).videos;
  }

  @Get('/:id/about')
  @UseGuards(JwtAuthGuard)
  async channelProfile(
    @Param('id', new ParseIntPipe())
    channelId: number,
    @User() user,
  ) {
    return await this.channelService.getChannelProfile(channelId, user.id);
  }
}
