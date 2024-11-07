import { TransactionStatus } from '@/entities/enums/transaction-status.enum';
import { Expose } from 'class-transformer';

export class PaymentHistoryDto {
  @Expose()
  id: number;

  @Expose()
  createdAt: Date;

  @Expose()
  status: TransactionStatus; // email

  @Expose()
  email: string;

  @Expose()
  fullName: string;

  @Expose()
  numberOfREPs: number;

  @Expose()
  price: number;
}
