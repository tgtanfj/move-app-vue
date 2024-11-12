import { Column, Entity, ManyToOne, OneToMany, OneToOne } from 'typeorm';
import { Account } from './account.entity';
import { BaseEntity } from './base/base.entity';
import { Channel } from './channel.entity';
import { CommentReaction } from './comment-reaction.entity';
import { Comment } from './comment.entity';
import { Country } from './country.entity';
import { Donation } from './donation.entity';
import { Gender } from './enums/gender.enum';
import { Role } from './enums/role.enum';
import { Follow } from './follow.entity';
import { Payment } from './payment.entity';
import { RefreshToken } from './refresh-token.entity';
import { SearchHistory } from './search-history.entity';
import { State } from './state.entity';
import { WatchingVideoHistory } from './watching-video-history.entity';

@Entity('users')
export class User extends BaseEntity {
  @Column({
    type: 'varchar',
    nullable: false,
    length: 100,
    unique: true,
  })
  email: string;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  username: string;

  @Column({
    type: 'date',
    nullable: true,
  })
  dateOfBirth: Date;

  @Column({
    type: 'enum',
    enum: Gender,
    nullable: true,
  })
  gender: Gender;

  @Column({
    type: 'enum',
    enum: Role,
    default: Role.VIEWER,
  })
  role: Role;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  fullName: string;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  city: string;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  stripeId: string;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  avatar: string;

  @Column({
    type: 'bigint',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseInt(value, 10),
    },
  })
  numberOfREPs: number;

  @OneToOne(() => Account, (account) => account.user)
  account: Account;

  @OneToOne(() => Channel, (channel) => channel.user)
  channel: Channel;

  @OneToMany(() => Comment, (comment) => comment.user)
  comments: Comment[];

  @OneToMany(() => RefreshToken, (refreshToken) => refreshToken.user)
  refreshTokens: RefreshToken[];

  @OneToMany(() => Payment, (payment) => payment.user)
  payments: Payment[];

  @OneToMany(() => SearchHistory, (searchHistory) => searchHistory.user)
  searchHistories: SearchHistory[];

  @OneToMany(() => Donation, (donation) => donation.user)
  donations: Donation[];

  @OneToMany(() => Follow, (follow) => follow.user)
  follows: Follow[];

  @OneToMany(() => WatchingVideoHistory, (watchingVideoHistory) => watchingVideoHistory.user)
  watchingVideoHistories: WatchingVideoHistory[];

  @ManyToOne(() => Country, (country) => country.id)
  country: Country;

  @ManyToOne(() => State, (state) => state.id)
  state: State;

  @OneToMany(() => CommentReaction, (commentReaction) => commentReaction.user)
  commentReactions: CommentReaction[];

  @Column({
    type: 'varchar',
    nullable: true,
  })
  token: string;
}
