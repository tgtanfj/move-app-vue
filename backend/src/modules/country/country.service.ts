import { Country } from '@/entities/country.entity';
import { CountryRepository } from './country.repository';
import { State } from '@/entities/state.entity';
import { BadRequestException, Injectable } from '@nestjs/common';

@Injectable()
export class CountryService {
  constructor(private readonly countryRepository: CountryRepository) {}

  async getStatesOfCountry(id: number): Promise<State[]> {
    return await this.countryRepository.getStatesOfCountry(id).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async getAllCountries(): Promise<Country[]> {
    return await this.countryRepository.getAllCountries().catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async getAllCountriesAndStates(): Promise<Country[]> {
    return await this.countryRepository.getAllCountriesAndStates().catch((error) => {
      throw new BadRequestException(error.message);
    });
  }
}
