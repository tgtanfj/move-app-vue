export class PaginationMetadata {
  total: number;

  page: number;

  take: number;

  totalPages: number;

  constructor(total?: number, page?: number, take?: number, totalPages?: number) {
    this.total = total;
    this.page = page;
    this.take = take;
    this.totalPages = totalPages;
  }
}
