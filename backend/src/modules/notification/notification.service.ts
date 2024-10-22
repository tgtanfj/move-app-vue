import { Injectable } from '@nestjs/common';
import {
  MultipleDeviceNotificationDto,
  NotificationDto,
  TopicNotificationDto,
} from './dto/send-notification.dto';
import * as admin from 'firebase-admin';
import { db } from '@/shared/firebase/firebase.config';
import { CommonNotificationDto } from './dto/common-notification.dto';
import { SystemNotificationDto } from './dto/system-notification.dto';
@Injectable()
export class NotificationService {
  async sendNotification({ token, title, body, icon }: NotificationDto) {
    try {
      const response = await admin.messaging().send({
        token,
        webpush: {
          notification: {
            title,
            body,
            icon,
          },
        },
      });
      return response;
    } catch (error) {
      throw error;
    }
  }

  async sendNotificationToMultipleTokens({ tokens, title, body, icon }: MultipleDeviceNotificationDto) {
    const message = {
      notification: {
        title,
        body,
        icon,
      },
      tokens,
    };

    try {
      const response = await admin.messaging().sendMulticast(message);
      console.log('Successfully sent messages:', response);
      return {
        success: true,
        message: `Successfully sent ${response.successCount} messages; ${response.failureCount} failed.`,
      };
    } catch (error) {
      console.log('Error sending messages:', error);
      return { success: false, message: 'Failed to send notifications' };
    }
  }

  async sendTopicNotification({ topic, title, body, icon }: TopicNotificationDto) {
    const message = {
      notification: {
        title,
        body,
        icon,
      },
      topic,
    };

    try {
      const response = await admin.messaging().send(message);
      console.log('Successfully sent message:', response);
      return { success: true, message: 'Topic notification sent successfully' };
    } catch (error) {
      console.log('Error sending message:', error);
      return { success: false, message: 'Failed to send topic notification' };
    }
  }

  async sendOneToOneNotification(userId: number, data: CommonNotificationDto | SystemNotificationDto) {
    const notificationRef = db.ref(`notifications/${userId}`).push();
    await notificationRef.set({ data, isRead: false, timestamp: Date.now() });
  }

  async sendOneToManyNotifications(userIds: number[], data: CommonNotificationDto | SystemNotificationDto) {
    const promises = userIds.map(async (userId) => {
      const notificationRef = db.ref(`notifications/${userId}`).push();
      return notificationRef.set({ data, isRead: false, timestamp: Date.now() });
    });
    await Promise.all(promises);
  }

  async sendBroadcastNotification(data: SystemNotificationDto) {
    const notificationsRef = db.ref(`notifications`);
    const userSnapshots = await notificationsRef.once('value');
    const promises = [];
    userSnapshots.forEach((userSnapshot) => {
      const userId = userSnapshot.key;
      const notificationRef = db.ref(`notifications/${userId}`).push();
      promises.push(notificationRef.set({ data, isRead: false, timestamp: Date.now() }));
    });
    await Promise.all(promises);
  }
}
