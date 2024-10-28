import { Role } from '@/entities/enums/role.enum';
import { Roles } from '@/shared/decorators/roles.decorator';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { RolesGuard } from '@/shared/guards/roles.guard';
import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
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
  async getAllPaymentMethod(@User() user) {
    return this.stripeService.listPaymentMethod(user.stripeId);
  }

  @Post('attach-card')
  async attachPaymentMethod(@User() user, @Body() addPaymentMethod: AttachPaymentMethodDto) {
    return this.stripeService.attachPaymentMethod(user.stripeId, addPaymentMethod);
  }

  @Post('detach-card')
  async detachPaymentMethod(@Body() detachPaymentMethod: AttachPaymentMethodDto) {
    return this.stripeService.detachPaymentMethod(detachPaymentMethod);
  }

  @Get('balance')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  async getBalance() {
    return await this.stripeService.getBalance();
  }

  @Get('revenue')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  async getTotalRevenues() {
    return await this.stripeService.getTotalRevenue();
  }
}
