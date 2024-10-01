import { Column, Entity, JoinColumn, OneToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { TypeAccount } from './enums/typeAccount.enum';
import { User } from './user.entity';

@Entity('accounts')
export class Account extends BaseEntity {
  @Column({
    type: 'varchar',
    nullable: true,
  })
  password: string;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  oldPassword: string;

  @Column({
    type: 'enum',
    enum: TypeAccount,
    default: TypeAccount.NORMAL,
  })
  type: TypeAccount;

  @OneToOne(() => User, (user) => user.account)
  @JoinColumn({ name: 'userId' })
  user: User;
}
