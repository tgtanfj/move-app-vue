import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { validateDate } from '@/shared/utils/validate-date.util';
import {
  BadRequestException,
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { BuyREPsDto } from './dto/buy-reps.dto';
import QueryPaymentHistoryDto from './dto/query-payment-history.dto';
import { WithDrawDto } from './dto/withdraw.dto';
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
    return await this.paymentService.listRepsPackage();
  }

  @Post('buy-reps')
  @HttpCode(HttpStatus.OK)
  async buyREPs(@User() user, @Body() buyREPsDto: BuyREPsDto) {
    return this.paymentService.buyREPs(user, buyREPsDto);
  }

  @Get('/history')
  @HttpCode(HttpStatus.OK)
  async getPaymentHistory(@User() user, @Query() queryPaymentHistoryDto: QueryPaymentHistoryDto) {
    try {
      validateDate(queryPaymentHistoryDto.startDate, queryPaymentHistoryDto.endDate);

      return await this.paymentService.getPaymentHistory(user.id, queryPaymentHistoryDto);
    } catch (err) {
      throw new BadRequestException(err);
    }
  }

  @Post('withdraw')
  async createPayout(@User() user, @Body() withDrawDto: WithDrawDto) {
    return await this.paymentService.withDraw(user.id, withDrawDto);
  }
}
