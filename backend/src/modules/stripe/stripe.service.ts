import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { BadRequestException, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';
import { AttachPaymentMethodDto } from './dto/attach-payment-method.dto';
import { I18nService } from 'nestjs-i18n';

@Injectable()
export class StripeService {
  private stripe: Stripe;
  constructor(
    private configService: ConfigService,
    private readonly i18n: I18nService,
  ) {
    this.stripe = new Stripe(this.configService.get<string>('STRIPE_SECRET_KEY'), {
      apiVersion: '2024-06-20',
    });
  }

  async createCustomer(email: string) {
    return this.stripe.customers.create({
      email,
    });
  }

  async listPaymentMethod(customerId: string) {
    const paymentMethods = await this.stripe.customers.listPaymentMethods(customerId, {
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

    await this.stripe.paymentMethods
      .attach(paymentMethodId, {
        customer: customerId,
      })
      .catch((err) => {
        console.log(err);
        throw new BadRequestException(this.i18n.t('exceptions.payment.ADD_PAYMENT_METHOD_FAIL'));
      });
  }

  async detachPaymentMethod(detachPaymentMethod: AttachPaymentMethodDto) {
    const { paymentMethodId } = detachPaymentMethod;

    await this.stripe.paymentMethods.detach(paymentMethodId).catch((err) => {
      console.log(err);
      throw new BadRequestException(this.i18n.t('exceptions.payment.DETACH_PAYMENT_METHOD_FAIL'));
    });
  }

  async charge(amount: number, paymentMethodId: string, customerId: string) {
    return this.stripe.paymentIntents.create({
      amount: amount * 100,
      customer: customerId,
      payment_method: paymentMethodId,
      currency: this.configService.get('STRIPE_CURRENCY'),
      off_session: true,
      confirm: true,
    });
  }

  async getBalance() {
    return await this.stripe.balance.retrieve();
  }
}
