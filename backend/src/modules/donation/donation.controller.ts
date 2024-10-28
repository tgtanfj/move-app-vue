import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { Body, Controller, Get, HttpCode, HttpStatus, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { DonationService } from './donation.service';
import { DonationDto } from './dto/donation.dto';

@Controller('donation')
@ApiBearerAuth('jwt')
@UseGuards(JwtAuthGuard)
@ApiTags('Donation')
export class DonationController {
  constructor(private readonly donationService: DonationService) {}

  @Get('list-gift-packages')
  async getGiftPackage() {
    return await this.donationService.getGiftPackages();
  }

  @Post()
  @HttpCode(HttpStatus.OK)
  async donation(@User() user, @Body() donationDto: DonationDto) {
    return await this.donationService.donation(user, donationDto);
  }
}
