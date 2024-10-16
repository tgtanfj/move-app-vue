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
          (json['numberOfViews'] is int) ? json['numberOfViews'] : 0,
      ratings: (json['ratings'] is double) ? json['ratings'] : 0,
      urlS3: (json['urlS3'] is String) ? json['urlS3'] : '',
      categories: CategoryModel.fromJson(json['category']),
      channel: ChannelModel.fromJson(json['channel']),
    );
  }
}
