import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { Body, Controller, Get, HttpCode, HttpStatus, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { BuyREPsDto } from './dto/buy-reps.dto';
import { PaymentService } from './payment.service';

@Controller('payment')
@ApiTags('Payment')
@ApiBearerAuth('jwt')
@UseGuards(JwtAuthGuard)
export class PaymentController {
  constructor(private readonly paymentService: PaymentService) {}

  @Get('list-reps-package')
  @HttpCode(HttpStatus.OK)
  async listRepsPackage() {
    return this.paymentService.listRepsPackage();
  }

  @Post('buy-reps')
  @HttpCode(HttpStatus.OK)
  async buyREPs(@User() user, @Body() buyREPsDto: BuyREPsDto) {
    return this.paymentService.buyREPs(user, buyREPsDto);
  }
}
