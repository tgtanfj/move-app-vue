import { Body, Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { VideoService } from './video.service';
import { User } from '@/shared/decorators/user.decorator';
import { PaginationDto } from './dto/request/pagination.dto';
import { ApiBearerAuth, ApiQuery, ApiTags, getSchemaPath } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/shared/guards/jwt-auth.guard';

@ApiBearerAuth('jwt')
@ApiTags('video')
@Controller('video')
export class VideoController {
  constructor(private readonly videoService: VideoService) {}

  @Get('/dashboard')
  @UseGuards(JwtAuthGuard)
  // @Roles(Role.INSTRUCTOR)
  async getVideosDashboard(@User() user, @Query() paginationDto: PaginationDto) {
    return await this.videoService.getVideosDashboard(user.id, paginationDto);
  }
}
