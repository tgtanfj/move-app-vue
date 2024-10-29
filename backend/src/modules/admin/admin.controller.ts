import { Controller, Get, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/shared/guards';
import { RolesGuard } from '@/shared/guards/roles.guard';
import { RevenueDto } from './dto/response/revenue.dto';

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
}
