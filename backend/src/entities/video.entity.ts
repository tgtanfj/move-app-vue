import { Column, Entity, ManyToOne, OneToMany } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { WorkoutLevel } from './enums/workoutLevel.enum';
import { DurationType } from './enums/durationType.enum';
import { Channel } from './channel.entity';
import { Donation } from './donation.entity';
import { WatchingVideoHistory } from './watching-video-history.entity';
import { Comment } from './comment.entity';
import { Category } from './category.entity';

@Entity('videos')
export class Video extends BaseEntity {
  @Column({
    type: 'varchar',
  })
  title: string;

  @Column({
    type: 'enum',
    enum: WorkoutLevel,
  })
  workoutLevel: WorkoutLevel;

  @Column({
    type: 'enum',
    enum: DurationType,
  })
  duration: DurationType;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  keywords: string;

  @Column({
    type: 'boolean',
  })
  isCommentable: boolean;

  @Column({
    type: 'varchar',
  })
  url: string;

  @Column({
    type: 'varchar',
  })
  thumbnail_url: string;

  @ManyToOne(() => Channel, (channel) => channel.videos)
  channel: Channel;

  @OneToMany(() => Comment, (comment) => comment.video)
  comments: Comment[];

  @OneToMany(() => Donation, (donation) => donation.video)
  donations: Donation[];

  @OneToMany(() => WatchingVideoHistory, (watchingVideoHistory) => watchingVideoHistory.video)
  watchingVideoHistories: WatchingVideoHistory[];

  @ManyToOne(() => Category, (category) => category.videos)
  category: Category;

  @Column({
    type: 'boolean',
    default: false,
  })
  isPublish: boolean;
}
