import { fixIntNumberResponse } from '@/shared/utils/fix-number-response.util';

export class PaginationMetadata {
  total: number;

  page: number;

  take: number;

  totalPages: number;

  constructor(total?: number, page?: number, take?: number, totalPages?: number) {
    this.total = fixIntNumberResponse(total);
    this.page = fixIntNumberResponse(page);
    this.take = fixIntNumberResponse(take);
    this.totalPages = fixIntNumberResponse(totalPages);
  }
}
