import { Module } from '@nestjs/common';
import { FaqsService } from './faqs.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FAQs } from '@/entities/faq.entity';
import { FaqsRepository } from './faqs.repository';
import { FaqsController } from './faqs.controller';

@Module({
  imports: [TypeOrmModule.forFeature([FAQs])],
  controllers: [FaqsController],
  providers: [FaqsService, FaqsRepository],
  exports: [FaqsService],
})
export class FaqsModule {}
