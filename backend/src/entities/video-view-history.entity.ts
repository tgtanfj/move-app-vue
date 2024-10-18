import { Column, Entity, Index, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Video } from './video.entity';
import { BaseEntity } from './base/base.entity';

@Entity('video_view_history')
export class VideoViewHistorys extends BaseEntity {
  @ManyToOne(() => Video, (video) => video.viewHistories, { onDelete: 'CASCADE' })
  video: Video;

  @Index()
  @Column({
    type: 'date',
  })
  viewDate: string;

  @Column({
    type: 'bigint',
    default: 0,
  })
  views: number;
}
