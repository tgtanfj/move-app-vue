import { Column, Entity, ManyToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { Channel } from './channel.entity';
import { TransactionStatus } from './enums/transaction-status.enum';

@Entity('cashouts')
export class Cashout extends BaseEntity {
  @Column({
    type: 'bigint',
    default: 0,
  })
  numberOfREPs: number;

  @ManyToOne(() => Channel, (channel) => channel.cashouts)
  channel: Channel;

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
