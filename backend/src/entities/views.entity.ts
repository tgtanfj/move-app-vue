import { Column, Entity, ManyToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { Video } from './video.entity';

@Entity('views')
export class Views extends BaseEntity {
  @ManyToOne(() => Video, (video) => video.views)
  video: Video;

  @Column({
    type: 'date',
  })
  viewDate: Date;

  @Column({
    type: 'bigint',
    default: 1,
  })
  totalView: number;

  @Column({
    type: 'bigint',
    default: 0,
  })
  totalViewTime: number;
}
