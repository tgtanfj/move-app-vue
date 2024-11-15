import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/thumbnails_model.dart';

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
  final CategoryModel? category;
  final String? url;
  final String? urlS3;
  final CategoryModel? categories;
  final ChannelModel? channel;
  final int? durationsVideo;
  final bool? isCommentable;
  final List<ThumbnailsModel>? thumbnailsModel;
  final int? videoId;


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
    this.category,
    this.videoLength,
    this.isCommentable,
    this.thumbnailsModel,
    this.videoId,
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
    CategoryModel? category,
    int? videoLength,
    bool? isCommentable,
    List<ThumbnailsModel>? thumbnailsModel,
    int? videoId,
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
      category: category ?? this.category,
      videoLength: videoLength ?? this.videoLength,
      isCommentable: isCommentable ?? this.isCommentable,
      thumbnailsModel: thumbnailsModel ?? this.thumbnailsModel,
      videoId: videoId ?? this.videoId,
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
      categories: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : CategoryModel(title: ""),
      channel: json['channel'] != null
          ? ChannelModel.fromJson(json['channel'])
          : ChannelModel(name: ""),
      thumbnailURL:
          (json['thumbnailURL'] is String) ? json['thumbnailURL'] : '',
      thumbnailsModel: (json['thumbnails'] is List)
          ? (json['thumbnails'] as List<dynamic>?)
              ?.map((e) => ThumbnailsModel.fromJson(e))
              .toList()
          : [],
      durationsVideo:
          (json['durationsVideo'] is num) ? json['durationsVideo'].toInt() : 0,
      createdAt: (json['createdAt'] is String)
          ? DateTime.parse(json['createdAt'])
          : null,
      videoLength: json['videoLength'] is int ? json['videoLength'] : 0,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      isCommentable:
          (json['isCommentable'] != null && json['isCommentable'] is bool)
              ? json['isCommentable'] as bool
              : false,
      videoId: (json['videoId'] is int) ? json['videoId'] : 0,
    );
  }
}
