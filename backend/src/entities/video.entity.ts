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
import { VideoViewHistorys } from './video-view-history.entity';

@Entity('videos')
export class Video extends BaseEntity {
  @Index() // Tạo index cho trường title để tối ưu tìm kiếm
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

  // Liên kết với bảng Channel (Nhiều video thuộc về một Channel)
  @ManyToOne(() => Channel, (channel) => channel.videos)
  channel: Channel;

  // Liên kết với bảng Comment (Một video có nhiều bình luận)
  @OneToMany(() => Comment, (comment) => comment.video)
  comments: Comment[];

  // Liên kết với bảng Donation (Một video có thể có nhiều lượt donate)
  @OneToMany(() => Donation, (donation) => donation.video)
  donations: Donation[];

  // Liên kết với bảng WatchingVideoHistory (Lưu lịch sử xem của video)
  @OneToMany(() => WatchingVideoHistory, (watchingVideoHistory) => watchingVideoHistory.video)
  watchingVideoHistories: WatchingVideoHistory[];

  // Liên kết với bảng Category (Nhiều video thuộc một category)
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

  // Liên kết với bảng Thumbnail (Một video có nhiều thumbnail)
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
  // Liên kết với bảng VideoViewHistory (Một video có nhiều lịch sử lượt xem)
  @OneToMany(() => VideoViewHistorys, (videoViewHistory) => videoViewHistory.video)
  viewHistories: VideoViewHistorys[];

  // Trường không được lưu vào cơ sở dữ liệu, chỉ tính toán tạm thời
  viewGrowthRate?: number;
}
