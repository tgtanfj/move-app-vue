import { Column, Entity, OneToMany } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { Payment } from './payment.entity';
import { Donation } from './donation.entity';

@Entity('gift-packages')
export class GiftPackage extends BaseEntity {
  @Column({
    type: 'int',
    nullable: false,
  })
  numberOfREPs: number;

  @OneToMany(() => Donation, (donation) => donation.giftPackage)
  donations: Donation[];
}
