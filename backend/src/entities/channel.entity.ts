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
    nullable: true,
  })
  bio: string;

  @Column({
    type: 'varchar',
  })
  image: string;

  @Column({
    type: 'boolean',
    default: false,
  })
  isBlueBadge: boolean;

  @Column({
    type: 'boolean',
    default: false,
  })
  isPinkBadge: boolean;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  facebookLink: string;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  instagramLink: string;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  youtubeLink: string;

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
