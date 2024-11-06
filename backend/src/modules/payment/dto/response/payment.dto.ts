import { TransactionStatus } from '@/entities/enums/transaction-status.enum';
import { Expose, Transform, Type } from 'class-transformer';

export class RepsPackageDto {
  @Expose()
  numberOfREPs: number;
}

export default class PaymentDto {
  @Expose()
  @Transform(({ value }) => {
    const date = new Date(value);
    date.setHours(date.getHours() + 7);
    return date.toISOString();
  })
  @Type(() => Date)
  createdAt: Date;

  @Expose()
  repsPackage: RepsPackageDto;

  @Expose()
  status: TransactionStatus;
}
