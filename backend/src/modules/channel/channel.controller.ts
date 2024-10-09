import { Controller, Get, Param, ParseEnumPipe, ParseIntPipe, Query, UseGuards } from '@nestjs/common';
import { ChannelService } from './channel.service';
import { query } from 'express';
import { FilterVideoChannelDto, FilterWorkoutLevel, SortBy } from './dto/request/filter-video-channel.dto';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/shared/guards';
import { User } from '@/shared/decorators/user.decorator';
import { Public } from '@/shared/decorators/public.decorator';
import { QueryChannelDto } from './dto/request/query-channel.dto';
import { Type } from 'class-transformer';

@ApiTags('channel')
@Controller('channel')
export class ChannelController {
  constructor(private readonly channelService: ChannelService) {}

  @ApiQuery({ name: 'workout-level', enum: FilterWorkoutLevel, required: false })
  @ApiQuery({ name: 'categoryId', type: Number, required: false })
  @ApiQuery({ name: 'sort-by', enum: SortBy, required: false })
  @ApiQuery({ name: 'take', type: Number, required: false })
  @ApiQuery({ name: 'page', type: Number, required: false })
  @ApiBearerAuth('jwt')
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

  @ApiBearerAuth('jwt')
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
}
