import { Expose } from 'class-transformer';
import { Column, Entity, Index, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { State } from './state.entity';

@Entity('countries')
export class Country {
  @PrimaryGeneratedColumn('increment', {
    name: 'id',
  })
  @Index()
  @Expose()
  public id: number;

  @Column({
    type: 'varchar',
    nullable: false,
  })
  @Expose()
  name: string;

  @Column({
    type: 'varchar',
    nullable: true,
  })
  @Expose()
  countryCode: string;

  @OneToMany(() => State, (state) => state.country)
  states: State[];
}
