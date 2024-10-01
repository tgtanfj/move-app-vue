import { Column, Entity, ManyToOne, OneToMany } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { Video } from './video.entity';

@Entity('categories')
export class Category extends BaseEntity {
  @Column({
    type: 'varchar',
  })
  title: string;

  @Column({
    type: 'varchar',
  })
  image: string;

  @OneToMany(() => Video, (video) => video.category)
  videos: Video[];
}