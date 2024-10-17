import { Module } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { NotificationController } from './notification.controller';
import { firebaseAdminProvider } from '@/shared/providers/firebase-admin.provider';

@Module({
  controllers: [NotificationController],
  providers: [NotificationService, firebaseAdminProvider],
})
export class NotificationModule {}
