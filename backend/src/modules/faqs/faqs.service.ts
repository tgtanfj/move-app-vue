import { Injectable } from '@nestjs/common';
import { FaqsRepository } from './faqs.repository';
import { FAQs } from '@/entities/faq.entity';

@Injectable()
export class FaqsService {
  constructor(private readonly faqsRepository: FaqsRepository) {}

  // Create a new FAQ
  async create(faq: Partial<FAQs>): Promise<FAQs> {
    const newFaq = { ...faq, isActive: true };
    return this.faqsRepository.create(newFaq);
  }

  // Get all FAQs
  async findAll(): Promise<FAQs[]> {
    return this.faqsRepository.findAll();
  }

  // Get a single FAQ by ID
  async findOne(id: number): Promise<FAQs | null> {
    return this.faqsRepository.findId(id);
  }

  // Update an existing FAQ
  async update(id: number, faq: Partial<FAQs>): Promise<FAQs> {
    return this.faqsRepository.update(id, faq);
  }

  // Delete an FAQ by ID
  async remove(id: number): Promise<void> {
    return this.faqsRepository.remove(id);
  }
}
