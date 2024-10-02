import { Category } from '@/entities/category.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

export class CategoryRepository {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}
  async getAll() {
    return await this.categoryRepository.find({
      select: ['id', 'title'],
    });
  }

  async findCategoryById(categoryId: number): Promise<Category | null> {
    return await this.categoryRepository.findOne({ where: { id: categoryId } });
  }
}
