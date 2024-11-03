import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/shared/guards';
import { RolesGuard } from '@/shared/guards/roles.guard';
import { RevenueDto } from './dto/response/revenue.dto';
import { Role } from '@/entities/enums/role.enum';
import { Roles } from '@/shared/decorators/roles.decorator';
import UserQueryDto from './dto/request/user-query.dto';
import { User } from '@/entities/user.entity';
import VideoAdminQueryDto, { SortType, SortVideoAdmin } from './dto/request/video-admin-query.dto';

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

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  @Get('videos')
  async getVideoAdmin(@Query() videoAdminQuery: VideoAdminQueryDto) {
    return await this.adminService.getVideoAdmin(videoAdminQuery);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Get('users')
  async getUsers(@Query() userQueryDto: UserQueryDto) {
    return await this.adminService.getUsers(userQueryDto);
  }
}
