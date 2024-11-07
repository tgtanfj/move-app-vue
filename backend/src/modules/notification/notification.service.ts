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
import { Cron, CronExpression } from '@nestjs/schedule';
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

  @Cron(CronExpression.EVERY_DAY_AT_1AM)
  async deleteNotification() {
    const now = Date.now();
    const threshold = now - 60 * 24 * 60 * 60 * 1000;

    const notificationsRef = db.ref(`notifications`);
    const snapshot = await notificationsRef.once('value');
    const remove = [];
    snapshot.forEach((childSnapshot) => {
      const createdAt = childSnapshot.val().createdAt;
      if (createdAt < threshold) {
        remove.push(childSnapshot.ref.remove());
      }
    });
    await Promise.all(remove);
  }

  async setNotificationData(
    ref: admin.database.ThenableReference,
    data: CommonNotificationDto | SystemNotificationDto,
  ) {
    await ref.set({
      data,
      isRead: false,
      timestamp: Date.now(),
    });
  }

  async checkNotificationExistsAntiSpam(userId: number, data?: number) {
    const notificationsRef = db.ref(`notifications/${userId}`);
    const snapshot = await notificationsRef.get();

    if (!snapshot.exists()) {
      return false;
    }

    const notifications = snapshot.val();

    for (const notificationId in notifications) {
      const notification = notifications[notificationId];
      const type = notification.data?.type;
      const followMilestone = notification.data?.followMilestone;
      const viewVideoMilestone = notification.data?.viewVideoMilestone;
      const repMilestone = notification.data?.repMilestone;
      const commentId = notification.data?.commentId;

      if (type === NOTIFICATION_TYPE.LIKE && commentId === data) {
        return true;
      }

      if (
        (type === NOTIFICATION_TYPE.FOLLOW_MILESTONE && followMilestone === data) ||
        (type === NOTIFICATION_TYPE.VIEW_VIDEO_MILESTONE && viewVideoMilestone === data) ||
        (type === NOTIFICATION_TYPE.REP_MILESTONE && repMilestone === data)
      ) {
        return true;
      }
    }

    return false;
  }
}
