import { PartialType } from '@nestjs/mapped-types';
import { CreateSearchHistoryDto } from './create-search.dto';

export class UpdateSearchDto extends PartialType(CreateSearchHistoryDto) {}
