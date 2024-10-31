import { forwardRef, Module } from '@nestjs/common';
import { ViewService } from './view.service';
import { ViewController } from './view.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Views } from '@/entities/views.entity';
import { ViewRepository } from './view.repository';
import { VideoModule } from '../video/video.module';
import { NotificationModule } from '../notification/notification.module';
import { CategoryModule } from '../category/category.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Views]),
    forwardRef(() => VideoModule),
    NotificationModule,
    CategoryModule,
  ],
  controllers: [ViewController],
  providers: [ViewService, ViewRepository],
  exports: [ViewService, ViewRepository],
})
export class ViewModule {}
