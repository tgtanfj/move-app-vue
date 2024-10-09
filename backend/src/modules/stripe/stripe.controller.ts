import { User } from '@/shared/decorators/user.decorator';
import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AttachPaymentMethodDto } from './dto/attach-payment-method.dto';
import { StripeService } from './stripe.service';
import { JwtAuthGuard } from '@/shared/guards';

@Controller('stripe')
@ApiTags('stripe')
export class StripeController {
  constructor(private stripeService: StripeService) {}

  @Get('list-cards')
  @UseGuards(JwtAuthGuard)
  async getAllPaymentMethod(@User() user) {
    return this.stripeService.listPaymentMethod(user.stripeId);
  }

  @Post('attach-card')
  @UseGuards(JwtAuthGuard)
  async attachPaymentMethod(@User() user, @Body() addPaymentMethod: AttachPaymentMethodDto) {
    return this.stripeService.attachPaymentMethod(user.id, addPaymentMethod);
  }
}
