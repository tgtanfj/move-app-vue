import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';

class SuggestionModel {
  final CategoryModel? topCategory;
  final List<ChannelModel>? topInstructors;
  final List<VideoModel>? topVideos;

  SuggestionModel({
    this.topCategory,
    this.topInstructors,
    this.topVideos,
  });

  SuggestionModel copyWith({
    CategoryModel? topCategory,
    List<ChannelModel>? topInstructors,
    List<VideoModel>? topVideos,
  }) {
    return SuggestionModel(
      topCategory: topCategory ?? this.topCategory,
      topInstructors: topInstructors ?? this.topInstructors,
      topVideos: topVideos ?? this.topVideos,
    );
  }

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      topCategory: json['topCategory'] != null
          ? CategoryModel.fromJson(json['topCategory'])
          : CategoryModel(title: " "),
      topInstructors: (json['topInstructors'] is List?)
          ? (json['topInstructors'] as List?)
              ?.map((e) => ChannelModel.fromJson(e))
              .toList()
          : [],
      topVideos: (json['topVideos'] is List?)
          ? (json['topVideos'] as List?)
              ?.map((e) => VideoModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
