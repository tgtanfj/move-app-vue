import { Country } from '@/entities/country.entity';
import { State } from '@/entities/state.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { I18nService } from 'nestjs-i18n';
import { Equal, FindOptionsRelations, Repository } from 'typeorm';

@Injectable()
export class CountryRepository {
  constructor(
    @InjectRepository(Country) private readonly countryRepository: Repository<Country>,
    @InjectRepository(State) private readonly stateRepository: Repository<State>,
    private readonly i18n: I18nService,
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

    if (!foundCountry) throw new Error(this.i18n.t('exceptions.user.NOT_FOUND_ANY_COUNTRY'));

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
