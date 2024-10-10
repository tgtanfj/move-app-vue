import { Column, Entity, Index, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Video } from './video.entity';
import { BaseEntity } from './base/base.entity';

@Entity('video_view_history')
export class VideoViewHistorys extends BaseEntity {
  // Liên kết với bảng Video (Nhiều lịch sử lượt xem thuộc về một video)
  @ManyToOne(() => Video, (video) => video.viewHistories, { onDelete: 'CASCADE' })
  video: Video;

  // Ngày ghi nhận lượt xem của video
  @Index() // Tạo index cho viewDate để tối ưu hóa các truy vấn liên quan đến ngày
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
