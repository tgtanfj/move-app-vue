import { Country } from '@/entities/country.entity';
import { State } from '@/entities/state.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Equal, FindOptionsRelations } from 'typeorm';

@Injectable()
export class CountryRepository {
  constructor(
    @InjectRepository(Country) private readonly countryRepository: Repository<Country>,
    @InjectRepository(State) private readonly stateRepository: Repository<State>,
  ) {}

  async getAllCountries(relations: FindOptionsRelations<Country> = null) {
    return this.countryRepository.find({
      order: { name: 'ASC' },
      relations,
    });
  }

  async getAllStates() {
    return this.stateRepository.find({
      order: { name: 'ASC' },
    });
  }

  async getAllCountriesAndStates() {
    return this.countryRepository.find({
      relations: { states: true },
      order: { name: 'ASC', states: { name: 'ASC' } },
    });
  }

  async getStatesOfCountry(countryId: number) {
    const foundCountry = await this.countryRepository.findOne({
      where: {
        id: countryId,
      },
    });
    if (!foundCountry) throw new Error(ERRORS_DICTIONARY.NOT_FOUND_ANY_COUNTRY);

    const states = await this.stateRepository.find({
      where: {
        country: { id: Equal(countryId) },
      },
      order: {
        name: 'ASC',
      },
    });

    return states;
  }
}
