import { Entity, Column } from 'typeorm';
import { WorkoutLevel } from './enums/workoutLevel.enum';
import { DurationType } from './enums/durationType.enum';
import { BaseEntity } from './base/base.entity';

@Entity('videos-trend')
export class VideoTrend extends BaseEntity {
  @Column({
    type: 'bigint',
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseInt(value, 10),
    },
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
    type: 'bigint',
    default: 0,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseInt(value, 10),
    },
  })
  numberOfViews: number;

  @Column({
    type: 'int',
    default: 0,
  })
  videoLength: number;

  @Column({
    type: 'float',
    default: 0,
  })
  ratings: number;

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
    type: 'int',
  })
  categoryId: number;

  @Column({
    type: 'bigint',
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseInt(value, 10),
    },
  })
  channelId: number;
}
