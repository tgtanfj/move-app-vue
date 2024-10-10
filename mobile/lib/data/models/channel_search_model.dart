import 'package:move_app/data/models/channel_model.dart';

class ChannelSearchModel {
  final List<ChannelModel>? data;
  final int? totalPages;

  ChannelSearchModel({this.data, this.totalPages});

  ChannelSearchModel copyWith({
    List<ChannelModel>? data,
    int? totalPages,
  }) {
    return ChannelSearchModel(
      data: data ?? this.data,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  factory ChannelSearchModel.fromJson(Map<String, dynamic> json) {
    return ChannelSearchModel(
      data: (json['data'] is List)
          ? (json['data'] as List<dynamic>)
              .map((e) => ChannelModel.fromJson(e))
              .toList()
          : [],
      totalPages: (json['totalPages'] is int) ? json['totalPages'] : 0,
    );
  }
}
