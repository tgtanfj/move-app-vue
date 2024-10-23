import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { MultipleDeviceNotificationDto, TopicNotificationDto } from './dto/send-notification.dto';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { NotificationOneToOneDto } from './dto/notification-one-to-one.dto';
import { NotificationOneToManyDto } from './dto/notification-one-to-many.dto';
import { NotificationOneToAllDto } from './dto/notification-one-to-all.dto';
@ApiTags('notification')
@Controller('notification')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Post('send-notification')
  @ApiOperation({ summary: 'Send a push notification to a single device' })
  @ApiResponse({ status: 200, description: 'Notification sent successfully' })
  async sendNotification(@Body() body: { token: string; title: string; body: string; icon: string }) {
    return this.notificationService.sendNotification({
      token: body.token,
      title: body.title,
      body: body.body,
      icon: body.icon,
    });
  }

  @Post('send-multiple-notifications')
  @ApiOperation({ summary: 'Send push notifications to multiple devices' })
  @ApiResponse({ status: 200, description: 'Notifications sent successfully' })
  async sendMultipleNotifications(@Body() body: MultipleDeviceNotificationDto) {
    return this.notificationService.sendNotificationToMultipleTokens({
      tokens: body.tokens,
      title: body.title,
      body: body.body,
      icon: body.icon,
    });
  }

  @Post('send-topic-notification')
  @ApiOperation({ summary: 'Send a push notification to a topic' })
  @ApiResponse({
    status: 200,
    description: 'Topic notification sent successfully',
  })
  async sendTopicNotification(@Body() body: TopicNotificationDto) {
    return this.notificationService.sendTopicNotification({
      topic: body.topic,
      title: body.title,
      body: body.body,
      icon: body.icon,
    });
  }

  @Post('one-to-one')
  async sendOneToOne(@Body() body: NotificationOneToOneDto) {
    await this.notificationService.sendOneToOneNotification(body.userId, body.data);
    return { success: true };
  }

  @Post('one-to-many')
  async sendOneToMany(@Body() body: NotificationOneToManyDto) {
    await this.notificationService.sendOneToManyNotifications(body.userIds, body.data);
    return { success: true };
  }

  @Post('broadcast')
  async sendBroadcast(@Body() body: NotificationOneToAllDto) {
    await this.notificationService.sendBroadcastNotification(body.data);
    return { success: true };
  }
}
