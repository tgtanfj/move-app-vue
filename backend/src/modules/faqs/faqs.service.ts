import { Injectable } from '@nestjs/common';
import { FaqsRepository } from './faqs.repository';
import { FAQs } from '@/entities/faq.entity';
import { CreateFaqDto } from './dto/create-faq.dto';
import { UpdateFaqDto } from './dto/update-faq.dto';

@Injectable()
export class FaqsService {
  constructor(private readonly faqsRepository: FaqsRepository) {}

  // Create a new FAQ
  async create(faq: CreateFaqDto): Promise<FAQs> {
    const newFaq = {
      ...faq,
      isActive: faq.isActive !== undefined ? faq.isActive.toLowerCase() === 'true' : true,
    };
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
  async update(id: number, faq: UpdateFaqDto): Promise<FAQs> {
    const updatedFaq = {
      ...faq,
      isActive: faq.isActive !== undefined ? faq.isActive.toLowerCase() === 'true' : undefined,
    };
    return this.faqsRepository.update(id, updatedFaq);
  }

  // Delete an FAQ by ID
  async remove(id: number): Promise<void> {
    return this.faqsRepository.remove(id);
  }
}
