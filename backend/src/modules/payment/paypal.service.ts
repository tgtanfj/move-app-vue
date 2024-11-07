import { ApiConfigService } from '@/shared/services/api-config.service';
import { Injectable, InternalServerErrorException } from '@nestjs/common';
import axios from 'axios';
import { I18nService } from 'nestjs-i18n';

@Injectable()
export class PayPalService {
  private accessToken: string;

  constructor(
    private readonly configService: ApiConfigService,
    private readonly i18n: I18nService,
  ) {}

  // Method to get the access token using client credentials
  private async getAccessToken() {
    try {
      const response = await axios({
        url: 'https://api-m.sandbox.paypal.com/v1/oauth2/token',
        method: 'post',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        auth: {
          username: this.configService.getString('PAYPAL_CLIENT_ID'),
          password: this.configService.getString('PAYPAL_CLIENT_SECRET'),
        },
        params: {
          grant_type: 'client_credentials',
        },
      });

      this.accessToken = response.data.access_token;
      return this.accessToken;
    } catch (error) {
      console.error('Error fetching PayPal access token:', error);
      throw new InternalServerErrorException(this.i18n.t('exceptions.paypal.CANT_GET_ACCESS_TOKEN'));
    }
  }

  // Method to create a payout
  async createPayout(receiverEmail: string, amount: number, currency: string = 'USD') {
    const accessToken = await this.getAccessToken();

    const requestBody = {
      sender_batch_header: {
        sender_batch_id: `batch_${new Date().getTime()}`,
        email_subject: 'You have a payout!',
        email_message: 'You have received a payout!',
      },
      items: [
        {
          recipient_type: 'EMAIL',
          amount: {
            value: amount,
            currency: currency,
          },
          receiver: receiverEmail,
          note: 'Thanks for your business!',
          sender_item_id: `item_${new Date().getTime()}`,
        },
      ],
    };

    const response = await axios
      .post('https://api-m.sandbox.paypal.com/v1/payments/payouts', requestBody, {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
      })
      .catch((err) => {
        throw err.response.data?.message;
      });
    return response;
  }
}
