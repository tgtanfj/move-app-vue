import { Column, Entity, OneToMany } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { Payment } from './payment.entity';

@Entity('reps-packages')
export class RepsPackage extends BaseEntity {
  @Column({
    type: 'int',
    nullable: false,
  })
  numberOfREPs: number;

  @Column({
    type: 'float',
  })
  price: number;

  @OneToMany(() => Payment, (payment) => payment.repsPackage)
  payments: Payment[];
}
