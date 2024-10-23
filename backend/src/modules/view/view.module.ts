import { Module } from '@nestjs/common';
import { ViewService } from './view.service';
import { ViewController } from './view.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Views } from '@/entities/views.entity';
import { ViewRepository } from './view.repository';

@Module({
  imports: [TypeOrmModule.forFeature([Views])],
  controllers: [ViewController],
  providers: [ViewService, ViewRepository],
  exports: [ViewService, ViewRepository],
})
export class ViewModule {}
