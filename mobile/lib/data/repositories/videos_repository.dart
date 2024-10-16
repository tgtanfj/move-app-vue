import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/search_result_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/services/api_service.dart';

import '../../constants/constants.dart';

class VideosRepository {
  Future<Either<String, List<VideoModel>>> searchVideo(String query) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultVideo,
        queryParameters: {'q': query},
      );
      if (response.statusCode == 200) {
        final result = parseSearchResultVideo(response.data);
        return Right(result);
      } else {
        return const Left("Cannot load video");
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          final errorMessage =
              errorData['message'] ?? Constants.unknownErrorOccurred;
          return Left(errorMessage);
        } else {
          return Left(e.message.toString());
        }
      }
      return Left(e.toString());
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
