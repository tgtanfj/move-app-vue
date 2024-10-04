import { Module } from '@nestjs/common';
import { CountryService } from './country.service';
import { CountryController } from './country.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { State } from '@/entities/state.entity';
import { Country } from '@/entities/country.entity';
import { CountryRepository } from './country.repository';

@Module({
  imports: [TypeOrmModule.forFeature([Country, State])],
  controllers: [CountryController],
  providers: [CountryService, CountryRepository],
  exports: [CountryService],
})
export class CountryModule {}
