import { Column, Entity, ManyToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { User } from './user.entity';
import { Video } from './video.entity';

@Entity('watching-video-histories')
export class WatchingVideoHistory extends BaseEntity {
  @Column({
    type: 'int',
    default: 0,
  })
  times: number;

  @Column({
    type: 'int',
    default: 0,
  })
  rate: number;

  @ManyToOne(() => User, (user) => user.watchingVideoHistories)
  user: User;

  @ManyToOne(() => Video, (video) => video.watchingVideoHistories, { onDelete: 'SET NULL' })
  video: Video;
}
