import { Controller, Get, Param, ParseIntPipe } from '@nestjs/common';
import { CountryService } from './country.service';
import { State } from '@/entities/state.entity';
import { Country } from '@/entities/country.entity';
import { ApiBadRequestResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';

@ApiTags('countries')
@Controller('countries')
export class CountryController {
  constructor(private readonly countryService: CountryService) {}

  @ApiOkResponse({ description: 'Fetch data successfully' })
  @ApiBadRequestResponse({ description: ERRORS_DICTIONARY.NOT_FOUND_ANY_COUNTRY })
  @Get('/:id/states')
  async getStatesOfCountry(@Param('id', ParseIntPipe) id: number): Promise<State[]> {
    return await this.countryService.getStatesOfCountry(id);
  }

  @ApiOkResponse({ description: 'Fetch data successfully' })
  @Get('/')
  async getAllCountry(): Promise<Country[]> {
    return await this.countryService.getAllCountries();
  }

  @ApiOkResponse({ description: 'Fetch data successfully' })
  @Get('/states')
  async getAllCountriesAndStates(): Promise<Country[]> {
    return await this.countryService.getAllCountriesAndStates();
  }
}
