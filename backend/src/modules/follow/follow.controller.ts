import { Body, Controller, Delete, Get, Post, UseGuards } from '@nestjs/common';
import { FollowService } from './follow.service';
import { JwtAuthGuard } from '@/shared/guards';
import { User } from '@/shared/decorators/user.decorator';
import { ApiTags } from '@nestjs/swagger';
import { CreateFollowDto } from './dto/create-follow.dto';

@ApiTags('follow')
@Controller('follow')
export class FollowController {
  constructor(private readonly followService: FollowService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  async follow(@User() user, @Body() dto: CreateFollowDto) {
    return await this.followService.save(user.id, dto.channelId);
  }

  @UseGuards(JwtAuthGuard)
  @Delete()
  async unFollow(@User() user, @Body() dto: CreateFollowDto) {
    return await this.followService.unfollow(user.id, dto.channelId);
  }
  
  @Get()
  async getIntructors(@User() user) {}
}
