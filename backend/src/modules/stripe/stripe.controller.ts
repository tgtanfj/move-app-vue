import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { Body, Controller, Get, HttpCode, HttpStatus, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AttachPaymentMethodDto } from './dto/attach-payment-method.dto';
import { StripeService } from './stripe.service';

@Controller('stripe')
@ApiBearerAuth('jwt')
@UseGuards(JwtAuthGuard)
@ApiTags('stripe')
export class StripeController {
  constructor(private stripeService: StripeService) {}

  @Get('list-cards')
  @HttpCode(HttpStatus.OK)
  async getAllPaymentMethod(@User() user) {
    return this.stripeService.listPaymentMethod(user.stripeId);
  }

  @Post('attach-card')
  @HttpCode(HttpStatus.OK)
  async attachPaymentMethod(@User() user, @Body() addPaymentMethod: AttachPaymentMethodDto) {
    return this.stripeService.attachPaymentMethod(user.stripeId, addPaymentMethod);
  }

  @Post('detach-card')
  @HttpCode(HttpStatus.OK)
  async detachPaymentMethod(@Body() detachPaymentMethod: AttachPaymentMethodDto) {
    return this.stripeService.detachPaymentMethod(detachPaymentMethod);
  }
}
