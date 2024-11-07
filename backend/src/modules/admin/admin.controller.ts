import { Role } from '@/entities/enums/role.enum';
import { Roles } from '@/shared/decorators/roles.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { RolesGuard } from '@/shared/guards/roles.guard';
import { validateDate } from '@/shared/utils/validate-date.util';
import { BadRequestException, Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AdminService } from './admin.service';
import QueryAdminPaymentHistoryDto from './dto/request/admin-query-payment-history.dto';
import UserQueryDto from './dto/request/user-query.dto';
import VideoAdminQueryDto from './dto/request/video-admin-query.dto';
import { RevenueDto } from './dto/response/revenue.dto';
import RevenueRequestDto from './dto/request/revenue.dto';

@ApiTags('admin')
@ApiBearerAuth('jwt')
@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Get('revenue')
  async getRevenue(@Query() revenueQueryDto: RevenueRequestDto) {
    return await this.adminService.getRevenue(revenueQueryDto);
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

  @Get('cashout-histories')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  async getAllCashOutHistories(@Query() queryAdminPaymentHistoryDto: QueryAdminPaymentHistoryDto) {
    try {
      validateDate(queryAdminPaymentHistoryDto.startDate, queryAdminPaymentHistoryDto.endDate);

      return await this.adminService.getAllCashOutHistories(queryAdminPaymentHistoryDto);
    } catch (error) {
      throw new BadRequestException(error);
    }
  }

  @Get('payment-histories')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  async getAllPaymentHistories(@Query() queryAdminPaymentHistoryDto: QueryAdminPaymentHistoryDto) {
    try {
      validateDate(queryAdminPaymentHistoryDto.startDate, queryAdminPaymentHistoryDto.endDate);

      return await this.adminService.findAllPaymentHistories(queryAdminPaymentHistoryDto);
    } catch (error) {
      throw new BadRequestException(error);
    }
  }
}
