import { Column, Entity, ManyToOne, OneToMany } from 'typeorm';
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
    default: true,
  })
  isCommentable: boolean;

  @Column({
    type: 'varchar',
  })
  url: string;

  @Column({
    type: 'bigint',
    default: 0,
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
  })
  urlS3: string;

  @OneToMany(() => Views, (view) => view.video)
  views: Views[];
}
