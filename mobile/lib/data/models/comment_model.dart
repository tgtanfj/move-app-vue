import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/utils/util_date_time.dart';

import '../../constants/constants.dart';

class CommentModel {
  final int? id;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? deletedAt;
  final String? content;
  final int? numberOfLike;
  final UserModel? user;
  final int? videoId;
  final LikeStatus? likeStatus;
  final bool? isLike;
  final int? totalDonation;
  final int? numberOfReply;
  final ChannelModel? channel;
  final String? lastContentDonate;

  CommentModel(
      {this.id,
      this.updatedAt,
      this.createdAt,
      this.deletedAt,
      this.content,
      this.numberOfLike,
      this.user,
      this.videoId,
      this.likeStatus,
      this.isLike,
      this.totalDonation,
      this.numberOfReply,
      this.channel,
      this.lastContentDonate});

  String getTimeSinceCreated() {
    if (createdAt != null) {
      return createdAt!.getTimeDifference();
    }
    return Constants.justNow;
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    LikeStatus? status;

    if (json['isLike'] == null) {
      status = LikeStatus.unknown;
    } else if (json['isLike'] == true) {
      status = LikeStatus.liked;
    } else {
      status = LikeStatus.unliked;
    }

    return CommentModel(
      id: json['id'] as int?,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      content: json['content'] is String ? json['content'] : '',
      numberOfLike: json['numberOfLike'] as int?,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      channel: json['channel'] != null
          ? ChannelModel.fromJson(json['channel'])
          : null,
      likeStatus: status,
      totalDonation: json['totalDonation'] as int?,
      numberOfReply: json['numberOfReply'] as int?,
      lastContentDonate:
          json['lastContentDonate'] is String ? json['lastContentDonate'] : '',
    );
  }

  CommentModel copyWith(
      {int? id,
      DateTime? updatedAt,
      DateTime? createdAt,
      DateTime? deletedAt,
      String? content,
      int? numberOfLike,
      UserModel? user,
      LikeStatus? likeStatus,
      int? totalDonation,
      bool? isLike,
      int? numberOfReply,
      String? lastContentDonate}) {
    return CommentModel(
        id: id ?? this.id,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        deletedAt: deletedAt ?? this.deletedAt,
        content: content ?? this.content,
        numberOfLike: numberOfLike ?? this.numberOfLike,
        user: user ?? this.user,
        likeStatus: likeStatus ?? this.likeStatus,
        totalDonation: totalDonation ?? this.totalDonation,
        isLike: isLike ?? this.isLike,
        numberOfReply: numberOfReply ?? this.numberOfReply,
        lastContentDonate: lastContentDonate ?? this.lastContentDonate);
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': id,
      'content': content,
      'videoId': videoId,
    };
  }

  Map<String, dynamic> commentReactionToJson() {
    return {
      'isLike': isLike,
      'commentId': id,
    };
  }
}

enum LikeStatus { liked, unliked, unknown }
