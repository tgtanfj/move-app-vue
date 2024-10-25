import { forwardRef, Module } from '@nestjs/common';
import { ViewService } from './view.service';
import { ViewController } from './view.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Views } from '@/entities/views.entity';
import { ViewRepository } from './view.repository';
import { VideoViewHistorys } from '@/entities/video-view-history.entity';
import { VideoModule } from '../video/video.module';
import { NotificationModule } from '../notification/notification.module';
import { UserModule } from '../user/user.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Views, VideoViewHistorys]),
    forwardRef(() => VideoModule),
    NotificationModule,
  ],
  controllers: [ViewController],
  providers: [ViewService, ViewRepository],
  exports: [ViewService, ViewRepository],
})
export class ViewModule {}
