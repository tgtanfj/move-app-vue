import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/search_result_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/services/api_service.dart';

class VideosRepository {
  Future<List<VideoModel>> searchVideo(String query) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultVideo,
        queryParameters: {'q': query},
      );
      if (response.statusCode == 200) {
        final result = parseSearchResultVideo(response.data);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<VideoModel> parseSearchResultVideo(Map<String, dynamic> responseBody) {
    final parsed = ((responseBody['data'] is List)
        ? responseBody['data']
        : [])
        .cast<Map<String, dynamic>>();
    return parsed
        .map<VideoModel>((json) => VideoModel.fromJson(json))
        .toList();
  }
}
