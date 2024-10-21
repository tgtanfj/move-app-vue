import { Column, Entity, ManyToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { Channel } from './channel.entity';

@Entity('cashouts')
export class Cashout extends BaseEntity {
  @Column({
    type: 'bigint',
    default: 0,
  })
  numberOfREPs: number;

  @ManyToOne(() => Channel, (channel) => channel.cashouts)
  channel: Channel;
}
