import { Column, Entity, ManyToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { GiftPackage } from './gift-package.entity';
import { User } from './user.entity';
import { Video } from './video.entity';

@Entity('donations')
export class Donation extends BaseEntity {
  @Column({
    type: 'varchar',
    nullable: false,
    default: '',
  })
  content: string;

  @ManyToOne(() => User, (user) => user.donations)
  user: User;

  @ManyToOne(() => Video, (video) => video.donations, { onDelete: 'CASCADE' })
  video: Video;

  @ManyToOne(() => GiftPackage, (giftPackage) => giftPackage.donations)
  giftPackage: GiftPackage;
}
