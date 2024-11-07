import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/utils/util_date_time.dart';

class NotificationModel {
  final NotificationData data;
  final bool isRead;
  final bool hasDelete;
  final int timestamp;
  String? key;

  NotificationModel(
      {required this.data,
      required this.isRead,
      required this.hasDelete,
      required this.timestamp,
      this.key});

  NotificationModel copyWith({
    NotificationData? data,
    bool? isRead,
    int? timestamp,
    bool? hasDelete,
    String? key,
  }) {
    return NotificationModel(
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      hasDelete: hasDelete ?? this.hasDelete,
      timestamp: timestamp ?? this.timestamp,
      key: key ?? this.key,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json, String key) {
    return NotificationModel(
      key: key,
      data: (json['data'] is Map)
          ? NotificationData.fromJson(Map<String, dynamic>.from(json['data']))
          : NotificationData.fromJson({}),
      hasDelete: (json['hasDelete'] is bool) ? json['hasDelete'] : false,
      isRead: (json['isRead'] is bool) ? json['isRead'] : false,
      timestamp: (json['timestamp'] is int) ? json['timestamp'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'isRead': isRead,
      'timestamp': timestamp,
    };
  }

  String get formattedTime => UtilDateTime.formatTimestamp(timestamp);
}

class NotificationData {
  final UserModel? userModel;
  final NotificationType type;
  final int? commentId;
  final int? videoId;
  final int? replyId;
  final String? videoTitle;
  final String? content;
  final int? donation;
  final int? cashOut;
  final int? purchase;
  final int? followMilestone;
  final int? viewVideoMilestone;
  final int? repMilestone;

  NotificationData({
    this.userModel,
    required this.type,
    this.commentId,
    this.videoId,
    this.replyId,
    this.videoTitle,
    this.content,
    this.donation,
    this.cashOut,
    this.purchase,
    this.followMilestone,
    this.viewVideoMilestone,
    this.repMilestone,
  });

  NotificationData copyWith({
    UserModel? userModel,
    NotificationType? type,
    int? commentId,
    int? videoId,
    int? replyId,
    String? videoTitle,
    String? content,
    int? donation,
    int? cashOut,
    int? purchase,
    int? followMilestone,
    int? viewVideoMilestone,
    int? repMilestone,
  }) {
    return NotificationData(
      userModel: userModel ?? this.userModel,
      type: type ?? this.type,
      commentId: commentId ?? this.commentId,
      videoId: videoId ?? this.videoId,
      replyId: replyId ?? this.replyId,
      videoTitle: videoTitle ?? this.videoTitle,
      content: content ?? this.content,
      donation: donation ?? this.donation,
      cashOut: cashOut ?? this.cashOut,
      purchase: purchase ?? this.purchase,
      followMilestone: followMilestone ?? this.followMilestone,
      viewVideoMilestone: viewVideoMilestone ?? this.viewVideoMilestone,
      repMilestone: repMilestone ?? this.repMilestone,
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      userModel: (json['sender'] is Map)
          ? UserModel.fromJson(Map<String, dynamic>.from(json['sender']))
          : null,
      type: NotificationType.values.firstWhere(
        (type) => type.value == (json['type'] is String ? json['type'] : ''),
        orElse: () => NotificationType.follow,
      ),
      commentId: (json['commentId'] is int) ? json['commentId'] : 0,
      videoId: (json['videoId'] is int) ? json['videoId'] : 0,
      replyId: (json['replyId'] is int) ? json['replyId'] : 0,
      videoTitle: (json['videoTitle'] is String) ? json['videoTitle'] : '',
      content: (json['content'] is String) ? json['content'] : '',
      donation: (json['donation'] is int) ? json['donation'] : 0,
      cashOut: (json['cashout'] is int) ? json['cashout'] : 0,
      purchase: (json['purchase'] is int) ? json['purchase'] : 0,
      followMilestone:
          (json['follow_milestone'] is int) ? json['follow_milestone'] : 0,
      viewVideoMilestone: (json['view_video_milestone'] is int)
          ? json['view_video_milestone']
          : 0,
      repMilestone: (json['rep_milestone'] is int) ? json['rep_milestone'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': userModel?.toJson(),
      'type': type,
      'commentId': commentId,
      'videoId': videoId,
      'videoTitle': videoTitle,
      'content': content,
      'cashout': cashOut,
      'donation': donation,
      'purchase': purchase,
      'follow_milestone': followMilestone,
      'view_video_milestone': viewVideoMilestone,
      'rep_milestone': repMilestone
    };
  }
}

enum NotificationType {
  follow('follow'),
  like('like'),
  comment('comment'),
  reply('reply'),
  upload('upload'),
  donation('donation'),
  cashout('cashout'),
  purchase('purchase'),
  followMilestone('follow_milestone'),
  viewVideoMilestone('view_video_milestone'),
  repMilestone('rep_milestone'),
  passwordChangeReminder('password_change_reminder');

  final String value;

  const NotificationType(this.value);
}
