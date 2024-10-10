import 'package:move_app/data/models/user_model.dart';

class CommentModel {
  final int? id;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? deletedAt;
  final String? content;
  final int? numberOfLike;
  final UserModel? user;
  final String? timeConvert;
  final int? videoId;
  final LikeStatus? likeStatus;
  final bool? isLike;
  final int? totalDonation;

  CommentModel({
    this.id,
    this.updatedAt,
    this.createdAt,
    this.deletedAt,
    this.content,
    this.numberOfLike,
    this.user,
    this.timeConvert,
    this.videoId,
    this.likeStatus,
    this.isLike,
    this.totalDonation,
  });

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
      likeStatus: status,
      totalDonation: json['totalDonation'] as int?,
    );
  }

  CommentModel copyWith({
    int? id,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deletedAt,
    String? content,
    int? numberOfLike,
    UserModel? user,
    String? timeConvert,
    LikeStatus? likeStatus,
    int? totalDonation,
    bool? isLike,

  }) {
    return CommentModel(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      content: content ?? this.content,
      numberOfLike: numberOfLike ?? this.numberOfLike,
      user: user ?? this.user,
      timeConvert: timeConvert ?? this.timeConvert,
      likeStatus: likeStatus ?? this.likeStatus,
      totalDonation: totalDonation ?? this.totalDonation,
      isLike: isLike ?? this.isLike
    );
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
enum LikeStatus {
  liked,
  unliked,
  unknown
}