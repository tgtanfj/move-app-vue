import { Expose } from 'class-transformer';
import { Column, Entity, Index, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Country } from './country.entity';

@Entity('states')
export class State {
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

  @ManyToOne(() => Country, (country) => country.states)
  country: Country;
}
