import { FAQs } from '@/entities/faq.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class FaqsRepository {
  constructor(@InjectRepository(FAQs) private readonly faqsRepository: Repository<FAQs>) {}
  // Create a new FAQ
  async create(faq: Partial<FAQs>): Promise<FAQs> {
    const newFaq = this.faqsRepository.create(faq);
    return this.faqsRepository.save(newFaq);
  }
  
  // Get all FAQs
  async findAll(): Promise<FAQs[]> {
    return this.faqsRepository.find();
  }

  // Get a single FAQ by ID
  async findId(faqsId: number): Promise<FAQs | null> {
    return await this.faqsRepository.findOne({ where: { id: faqsId } });
  }

  // Update an existing FAQ
  async update(id: number, faq: Partial<FAQs>): Promise<FAQs> {
    await this.faqsRepository.update(id, faq);
    return this.faqsRepository.findOne({ where: { id } });
  }

  // Delete an FAQ by ID
  async remove(id: number): Promise<void> {
    await this.faqsRepository.delete(id);
  }
}
