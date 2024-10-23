import 'package:move_app/data/models/user_model.dart';

class NotificationModel {
  final int? id;
  final UserModel? userModel;
  final String? content;
  final String? createTime;
  final bool hasRead;
  final int? commentId;
  final int? donationId;
  final int? videoId;

  const NotificationModel({
    this.id,
    this.userModel,
    this.content,
    this.createTime,
    this.hasRead = false,
    this.commentId,
    this.donationId,
    this.videoId,
  });
}
