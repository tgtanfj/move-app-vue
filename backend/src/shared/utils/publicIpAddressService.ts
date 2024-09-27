import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';

@Injectable()
export class PublicIpAddressService {
  constructor(private httpService: HttpService) {}

  async getPublicIpAddress(): Promise<string> {
    try {
      const response = await this.httpService.get('https://api.ipify.org').toPromise();
      return response.data;
    } catch (error) {
      console.error('Error fetching public IP:', error);
      return null;
    }
  }
}
