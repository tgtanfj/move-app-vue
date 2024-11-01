import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/shared/guards';
import { RolesGuard } from '@/shared/guards/roles.guard';
import { RevenueDto } from './dto/response/revenue.dto';
import { DurationType } from '@/entities/enums/durationType.enum';
import { SortVideoAdmin } from './dto/request/sort-video-admin.dto';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { Role } from '@/entities/enums/role.enum';
import { Roles } from '@/shared/decorators/roles.decorator';
import UserQueryDto from './dto/request/user-query.dto';
import { User } from '@/entities/user.entity';

@ApiTags('admin')
@ApiBearerAuth('jwt')
@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Get('revenue')
  async getRevenue(): Promise<RevenueDto[]> {
    return await this.adminService.getRevenue();
  }

  @ApiQuery({ name: 'q', type: String, description: 'Search query', required: false })
  @ApiQuery({ name: 'workout-level', enum: WorkoutLevel, required: false })
  @ApiQuery({ name: 'duration', enum: DurationType, required: false })
  @ApiQuery({ name: 'sort-by', enum: SortVideoAdmin, required: false })
  @ApiQuery({ name: 'take', type: Number, required: false })
  @ApiQuery({ name: 'page', type: Number, required: false })
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  @Get('videos')
  async channelVideos(
    @Query('q') query: string,
    @Query('workout-level')
    workoutLevel: WorkoutLevel,
    @Query('duration')
    duration: DurationType,
    @Query('sort-by')
    sortBy: SortVideoAdmin,
    @Query('take')
    take: number = 10,
    @Query('page')
    page: number = 1,
  ) {
    return await this.adminService.getVideoAdmin(query, workoutLevel, duration, sortBy, {
      take,
      page,
    });
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Get('users')
  async getUsers(@Query() userQueryDto: UserQueryDto) {
    return await this.adminService.getUsers(userQueryDto);
  }
}
