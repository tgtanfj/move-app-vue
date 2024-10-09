import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { BadRequestException, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';
import { AttachPaymentMethodDto } from './dto/attach-payment-method.dto';

@Injectable()
export class StripeService {
  private stripe: Stripe;
  constructor(private configService: ConfigService) {
    this.stripe = new Stripe(this.configService.get<string>('STRIPE_SECRET_KEY'), {
      apiVersion: '2024-06-20',
    });
  }

  async createCustomer(email: string) {
    return this.stripe.customers.create({
      email,
    });
  }

  async listPaymentMethod(stripeId: string) {
    const paymentMethods = await this.stripe.customers.listPaymentMethods(stripeId, {
      type: 'card',
    });

    const paymentMethodFiltered = paymentMethods.data.map((paymentMethod) => ({
      id: paymentMethod.id,
      type: paymentMethod.type,
      card: {
        brand: paymentMethod.card.brand,
        last4: paymentMethod.card.last4,
        exp_month: paymentMethod.card.exp_month,
        exp_year: paymentMethod.card.exp_year,
      },
      name: paymentMethod.billing_details.name,
    }));

    return paymentMethodFiltered;
  }

  async attachPaymentMethod(customerId: string, addPaymentMethod: AttachPaymentMethodDto) {
    const { paymentMethodId } = addPaymentMethod;

    await this.stripe.setupIntents
      .create({
        customer: customerId,
        payment_method: paymentMethodId,
      })
      .catch((err) => {
        console.log(err);
        throw new BadRequestException(ERRORS_DICTIONARY.ADD_PAYMENT_METHOD_FAIL);
      });
  }
}
