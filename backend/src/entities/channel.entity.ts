import { Column, Entity, JoinColumn, OneToMany, OneToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { Cashout } from './cashout.entity';
import { Follow } from './follow.entity';
import { User } from './user.entity';
import { Video } from './video.entity';

@Entity('channels')
export class Channel extends BaseEntity {
  @Column({
    type: 'varchar',
  })
  name: string;

  @Column({
    type: 'varchar',
  })
  bio: string;

  @Column({
    type: 'varchar',
  })
  image: string;

  @OneToOne(() => User, (user) => user.channel)
  @JoinColumn({ name: 'userId' })
  user: User;

  @OneToMany(() => Video, (video) => video.channel)
  videos: Video[];

  @OneToMany(() => Cashout, (cashout) => cashout.channel)
  cashouts: Cashout[];

  @OneToMany(() => Follow, (follow) => follow.channel)
  follows: Follow[];
}
