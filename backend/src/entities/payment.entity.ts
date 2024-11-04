import { Column, Entity, ManyToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { TransactionStatus } from './enums/transaction-status.enum';
import { RepsPackage } from './reps-package.entity';
import { User } from './user.entity';

@Entity('payments')
export class Payment extends BaseEntity {
  @ManyToOne(() => User, (user) => user.payments)
  user: User;

  @ManyToOne(() => RepsPackage, (repsPackage) => repsPackage.payments)
  repsPackage: RepsPackage;

  @Column({
    type: 'enum',
    enum: TransactionStatus,
    default: TransactionStatus.PENDING,
  })
  status: TransactionStatus;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  reason: string;
}
