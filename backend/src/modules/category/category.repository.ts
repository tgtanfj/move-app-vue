import { Category } from '@/entities/category.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Injectable } from '@nestjs/common';

@Injectable()
export class CategoryRepository {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  async getAll(): Promise<Category[]> {
    return await this.categoryRepository.find({
      select: ['id', 'title'],
      order: {
        id: 'asc',
      },
    });
  }

  async findCategoryById(categoryId: number): Promise<Category | null> {
    return await this.categoryRepository.findOne({ where: { id: categoryId } });
  }

  async searchCategories(keyword: string): Promise<Category[]> {
    return this.categoryRepository
      .createQueryBuilder('category')
      .where('category.name ILIKE :keyword', { keyword: `%${keyword}%` })
      .getMany();
  }

  async save(category: Category) {
    return await this.categoryRepository.save(category);
  }
}
