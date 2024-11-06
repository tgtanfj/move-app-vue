import { Column, Entity, Index, ManyToOne, OneToMany } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { WorkoutLevel } from './enums/workoutLevel.enum';
import { DurationType } from './enums/durationType.enum';
import { Channel } from './channel.entity';
import { Donation } from './donation.entity';
import { WatchingVideoHistory } from './watching-video-history.entity';
import { Comment } from './comment.entity';
import { Category } from './category.entity';
import { Thumbnail } from './thumbnail.entity';
import { Views } from './views.entity';

@Entity('videos')
export class Video extends BaseEntity {
  @Index()
  @Column({
    type: 'varchar',
    length: 255,
  })
  title: string;

  @Column({
    type: 'enum',
    enum: WorkoutLevel,
    default: WorkoutLevel.BEGINNER,
  })
  workoutLevel: WorkoutLevel;

  @Column({
    type: 'enum',
    enum: DurationType,
    default: DurationType.LESS_30_MINS,
  })
  duration: DurationType;

  @Column({
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  keywords: string;

  @Column({
    type: 'boolean',
    default: true,
  })
  isCommentable: boolean;

  @Column({
    type: 'varchar',
    length: 255,
  })
  url: string;

  @Column({
    type: 'bigint',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseInt(value, 10),
    },
  })
  numberOfViews: number;

  @Column({
    type: 'float',
    default: 0,
  })
  ratings: number;

  @Column({
    type: 'bigint',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseInt(value, 10),
    },
  })
  numberOfComments: number;

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

  @Column({
    type: 'integer',
    default: 0,
  })
  shareCount: number;

  @OneToMany(() => Thumbnail, (thumbnail) => thumbnail.video)
  thumbnails: Thumbnail[];

  @Column({
    type: 'varchar',
    nullable: true,
    length: 255,
  })
  urlS3: string;

  @OneToMany(() => Views, (view) => view.video)
  views: Views[];

  @Column({
    type: 'float',
    default: 0,
  })
  durationsVideo: number;
}
