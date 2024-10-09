import { Entity, Column } from 'typeorm';
import { WorkoutLevel } from './enums/workoutLevel.enum';
import { DurationType } from './enums/durationType.enum';
import { BaseEntity } from './base/base.entity';

@Entity('videos-trend')
export class VideoTrend extends BaseEntity {
  @Column({
    type: 'bigint',
  })
  videoId: number;

  @Column({
    type: 'varchar',
    length: 255,
  })
  title: string;

  @Column({
    type: 'enum',
    enum: WorkoutLevel,
  })
  workoutLevel: WorkoutLevel;

  @Column({
    type: 'varchar',
    length: 255,
  })
  thumbnailURL: string;

  @Column({
    type: 'bigint',
  })
  numberOfViews: number;

  @Column({
    type: 'varchar',
    length: 50,
  })
  videoLength: string;

  @Column({
    type: 'int',
    default: 0,
  })
  ratings: number;

  @Column({
    type: 'varchar',
    length: 255,
  })
  category: string;

  @Column({
    type: 'timestamp',
    nullable: true,
  })
  createdAt: Date | null;

  @Column({
    type: 'enum',
    enum: DurationType,
  })
  duration: DurationType;

  @Column({
    type: 'varchar',
    length: 255,
  })
  channelName: string;

  @Column({
    type: 'varchar',
    length: 255,
  })
  channelImage: string;

  @Column({
    type: 'boolean',
    default: false,
  })
  isBlueBadge: boolean;

  @Column({
    type: 'boolean',
    default: false,
  })
  isPinkBadge: boolean;
}
