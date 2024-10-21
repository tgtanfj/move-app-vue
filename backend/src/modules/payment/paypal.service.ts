import { ApiConfigService } from '@/shared/services/api-config.service';
import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';

@Injectable()
export class PayPalService {
  private accessToken: string;

  constructor(private readonly configService: ApiConfigService) {}

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
      throw new InternalServerErrorException('Error fetching PayPal access token');
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

    try {
      const response = await axios.post('https://api-m.sandbox.paypal.com/v1/payments/payouts', requestBody, {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
      });
      return response.data;
    } catch (error) {
      console.error('Error creating payout:', error.response?.data || error);
      throw new InternalServerErrorException('Payout failed');
    }
  }

}
