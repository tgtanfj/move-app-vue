import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/list_categories.dart';

class SearchResultModel {
  final String? type;
  final List<dynamic>? data;

  SearchResultModel({
    this.type,
    this.data,
  });

  SearchResultModel copyWith({
    String? type,
    List<dynamic>? data,
  }) {
    return SearchResultModel(
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      type: (json['data']['type'] is String) ? json['data']['type'] : '',
      data: json['data']['type'] == 'categories'
          ? (json['data']['data'] as List<dynamic>)
              .map((e) => CategoryModel.fromJson(e))
              .toList()
          : json['data']['type'] == 'channels'
              ? (json['data']['data'] as List<dynamic>)
                  .map((e) => ChannelModel.fromJson(e))
                  .toList()
              : json['data']['type'] == 'channels'
                  ? (json['data']['data'] as List<dynamic>)
                      .map((e) => VideoModel.fromJson(e))
                      .toList()
                  : [],
    );
  }
}
