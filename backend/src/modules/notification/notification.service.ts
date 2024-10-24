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
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
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
    await this.setNotificationData(notificationRef, data);
  }

  async sendOneToManyNotifications(userIds: number[], data: CommonNotificationDto) {
    const promises = userIds.map(async (userId) => {
      const notificationRef = db.ref(`notifications/${userId}`).push();
      return this.setNotificationData(notificationRef, data);
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
      promises.push(this.setNotificationData(notificationRef, data));
    });
    await Promise.all(promises);
  }

  async setNotificationData(
    ref: admin.database.ThenableReference,
    data: CommonNotificationDto | SystemNotificationDto,
  ) {
    await ref.set({
      data,
      is_read: false,
      timestamp: Date.now(),
    });
  }

  async checkNotificationExistsAntiSpam(userId: number, senderId: number, data?: number) {
    const notificationsRef = db.ref(`notifications/${userId}`);
    const snapshot = await notificationsRef.get();

    if (!snapshot.exists()) {
      return false;
    }

    const notifications = snapshot.val();

    for (const notificationId in notifications) {
      const notification = notifications[notificationId];
      const type = notification.data?.type;
      const sender = notification.data?.sender;
      const follow_milestone = notification.data?.follow_milestone;
      const view_video_milestone = notification.data?.view_video_milestone;
      const rep_milestone = notification.data?.rep_milestone;

      if (
        (type === NOTIFICATION_TYPE.FOLLOW || type === NOTIFICATION_TYPE.LIKE) &&
        !data &&
        sender.id === senderId
      ) {
        return true;
      }

      if (
        (type === NOTIFICATION_TYPE.FOLLOW_MILESTONE && follow_milestone === data) ||
        (type === NOTIFICATION_TYPE.VIEW_VIDEO_MILESTONE && view_video_milestone === data) ||
        (type === NOTIFICATION_TYPE.REP_MILESTONE && rep_milestone === data)
      ) {
        return true;
      }
    }

    return false;
  }
}
