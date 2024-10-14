import { Injectable } from '@nestjs/common';

import { CategoryRepository } from './category.repository';
import { Category } from '@/entities/category.entity';

@Injectable()
export class CategoryService {
  constructor(private readonly categoryRepository: CategoryRepository) {}

  async findAll(): Promise<Category[]> {
    return await this.categoryRepository.getAll();
  }

  async searchCategories(keyword: string): Promise<Category[]> {
    return this.categoryRepository.searchCategories(keyword);
  }
}
