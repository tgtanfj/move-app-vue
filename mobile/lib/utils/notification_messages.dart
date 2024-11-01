import 'package:move_app/utils/util_number_format.dart';
import 'package:move_app/data/models/notification_model.dart';

class NotificationMessages {
  static const Map<String, String> prefixMessage = {
    'follow': ' started following you!',
    'like': ' liked your comment on',
    'comment': ' commented on your video',
    'reply': ' replied to your comment on the video',
    'upload': ' just uploaded a new video',
    'donation': ' has donated',
    'cashout': ' You have successfully withdrawn',
    'purchase': ' You’ve successfully purchased',
    'follow_milestone': ' Congratulations! You’ve just reached',
    'rep_milestone': ' You’ve earned',
    'password_change_reminder':
        " Please update your password as it hasn't been changed for 90 days.",
  };

  static String viewVideoMilestone(String videoTitle) =>
      " Your video ‘$videoTitle’ has surpassed";

  static String mainContentMessage(NotificationModel? notification) {
    final data = notification?.data;
    switch (data?.type.value) {
      case 'like':
      case 'comment':
      case 'reply':
      case 'upload':
        return " '${data?.videoTitle}'.";
      case 'donation':
        return " ${UtilNumberFormat.formatWithCommas(data?.donation ?? 0)} REPs ";
      case 'cashout':
        return " \$${UtilNumberFormat.formatWithCommas(data?.cashOut ?? 0)}.";
      case 'purchase':
        return ' ${UtilNumberFormat.formatWithCommas(data?.purchase ?? 0)} REPs.';
      case 'follow_milestone':
        return ' ${UtilNumberFormat.formatWithCommas(data?.followMilestone ?? 0)} followers.';
      case 'view_video_milestone':
        return ' ${UtilNumberFormat.formatWithCommas(data?.viewVideoMilestone ?? 0)} views.';
      case 'rep_milestone':
        return ' ${UtilNumberFormat.formatWithCommas(data?.repMilestone ?? 0)} REPs';
      default:
        return '';
    }
  }

  static String suffixMessage(NotificationModel? notification) {
    final data = notification?.data;
    switch (data?.type.value) {
      case 'like':
      case 'comment':
      case 'reply':
      case 'upload':
      case 'cashout':
      case 'purchase':
      case 'follow_milestone':
      case 'view_video_milestone':
        return '';
      case 'donation':
        return "to your video";
      case 'rep_milestone':
        return ' in total from your content.';
      default:
        return '';
    }
  }

  static String afterSufMessage(NotificationModel? notification) {
    final data = notification?.data;
    final notificationType = data?.type.value;

    switch (notificationType) {
      case 'like':
      case 'comment':
      case 'reply':
      case 'upload':
      case 'cashout':
      case 'purchase':
      case 'follow_milestone':
      case 'view_video_milestone':
      case 'rep_milestone':
        return '';
      case 'donation':
        return " '${data?.videoTitle}'.";
      default:
        return '';
    }
  }
}
