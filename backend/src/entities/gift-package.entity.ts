import { Column, Entity, OneToMany } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { Donation } from './donation.entity';

@Entity('gift-packages')
export class GiftPackage extends BaseEntity {
  @Column({
    type: 'int',
    nullable: false,
  })
  numberOfREPs: number;

  @Column({
    type: 'varchar',
    nullable: false,
    default: '',
  })
  image: string;

  @OneToMany(() => Donation, (donation) => donation.giftPackage)
  donations: Donation[];
}
