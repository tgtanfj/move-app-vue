import { Expose } from 'class-transformer';

export class RevenueDto {
  @Expose()
  id: number; // id User

  @Expose()
  fullName: string; // fullName

  @Expose()
  email: string; // email

  totalTopUp?: number = 0;

  totalDonations?: number = 0;

  totalEarnings?: number = 0;
}
