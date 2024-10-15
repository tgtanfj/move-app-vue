import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';

class VideoModel {
  final int? id;
  final String? title;
  final String? workoutLevel;
  final String? duration;
  final String? url;
  final int? numberOfViews;
  final double? ratings;
  final String? urlS3;
  final CategoryModel? categories;
  final ChannelModel? channel;
  final String? thumbnailURL;
  final int? durationsVideo;
  final DateTime? createdAt;

  VideoModel({
    this.id,
    this.title,
    this.workoutLevel,
    this.duration,
    this.url,
    this.numberOfViews,
    this.ratings,
    this.urlS3,
    this.categories,
    this.channel,
    this.thumbnailURL,
    this.durationsVideo,
    this.createdAt,
  });

  VideoModel copyWith({
    int? id,
    String? title,
    String? workoutLevel,
    String? duration,
    String? url,
    int? numberOfViews,
    double? ratings,
    String? urlS3,
    CategoryModel? categories,
    ChannelModel? channel,
    String? thumbnailURL,
    int? durationsVideo,
    DateTime? createdAt,
  }) {
    return VideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      workoutLevel: workoutLevel ?? this.workoutLevel,
      duration: duration ?? this.duration,
      url: url ?? this.url,
      numberOfViews: numberOfViews ?? this.numberOfViews,
      ratings: ratings ?? this.ratings,
      urlS3: urlS3 ?? this.urlS3,
      categories: categories ?? this.categories,
      channel: channel ?? this.channel,
      thumbnailURL: thumbnailURL ?? this.thumbnailURL,
      durationsVideo: durationsVideo ?? this.durationsVideo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: (json['id'] is int) ? json['id'] : 0,
      title: (json['title'] is String) ? json['title'] : '',
      workoutLevel:
          (json['workoutLevel'] is String) ? json['workoutLevel'] : '',
      duration: (json['duration'] is String) ? json['duration'] : '',
      url: (json['url'] is String) ? json['url'] : '',
      numberOfViews:
          (json['numberOfViews'] is num) ? json['numberOfViews'].toInt() : 0,
      ratings: (json["ratings"] is num) ? json['ratings'].toDouble() : 0.0,
      urlS3: (json['urlS3'] is String) ? json['urlS3'] : '',
      categories: CategoryModel.fromJson(json['category']),
      channel: ChannelModel.fromJson(json['channel']),
      thumbnailURL:
          (json['thumbnailURL'] is String) ? json['thumbnailURL'] : '',
      durationsVideo:
          (json['durationsVideo'] is num) ? json['durationsVideo'].toInt() : 0,
      createdAt: (json['createdAt'] is String)
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
