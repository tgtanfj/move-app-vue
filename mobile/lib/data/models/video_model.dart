import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_video_model.dart';

class VideoModel {
  final int? id;
  final String? thumbnailURL;
  final int? numberOfViews;
  final int? videoLength;
  final String? title;
  final double? ratings;
  final String? workoutLevel;
  final String? duration;
  final DateTime? createdAt;
  final ChannelVideoModel? channel;
  final CategoryModel? category;

  VideoModel(
      {required this.id,
      this.thumbnailURL,
      this.numberOfViews,
      this.videoLength,
      this.title,
      this.ratings,
      this.workoutLevel,
      this.duration,
      this.channel,
      this.category,
      this.createdAt});

  VideoModel copyWith({
    int? id,
    String? thumbnailURL,
    int? numberOfViews,
    int? videoLength,
    String? title,
    double? ratings,
    String? workoutLevel,
    String? duration,
    DateTime? createdAt,
    ChannelVideoModel? channel,
    CategoryModel? category,
  }) {
    return VideoModel(
        id: id ?? this.id,
        thumbnailURL: thumbnailURL ?? this.thumbnailURL,
        numberOfViews: numberOfViews ?? this.numberOfViews,
        videoLength: videoLength ?? this.videoLength,
        title: title ?? this.title,
        ratings: ratings ?? this.ratings,
        workoutLevel: workoutLevel ?? this.workoutLevel,
        duration: duration ?? this.duration,
        channel: channel ?? this.channel,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt);
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json['id'] is int ? json['id'] : 0,
        thumbnailURL:
            json['thumbnailURL'] is String ? json['thumbnailURL'] : '',
        numberOfViews: json['numberOfViews'] is int ? json['numberOfViews'] : 0,
        videoLength: json['videoLength'] is int ? json['videoLength'] : 0,
        title: json['title'] is String ? json['title'] : '',
        ratings: json['ratings'] is double ? json['ratings'] : 0,
        workoutLevel:
            json['workoutLevel'] is String ? json['workoutLevel'] : '',
        duration: json['duration'] is String ? json['duration'] : '',
        createdAt: (json['createdAt'] is String)
            ? DateTime.parse(json['createdAt'])
            : null,
        channel: json['channel'] != null
            ? ChannelVideoModel.fromJson(json['channel'])
            : null,
        category: json['category'] != null
            ? CategoryModel.fromJson(json['category'])
            : null,
      );
}
