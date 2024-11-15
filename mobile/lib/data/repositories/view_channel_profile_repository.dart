import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/services/api_service.dart';

import '../../constants/api_urls.dart';

class ViewChannelProfileRepository {
  final ApiService apiService = ApiService();
  Future<Either<String, ChannelModel>> getViewChannelProfileAbout(
      int channelId) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        'channel/$channelId/about',
      );
      if (response.data != null) {
        final channel = ChannelModel.fromJson(response.data['data']);
        return Right(channel);
      } else {
        return const Left(Constants.channelNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<VideoModel>>> getViewChannelProfileVideos(
      int channelId,
      {int page = 1,
      int? categoryId,
      String? workoutLevel,
      String? sortBy}) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        'channel/$channelId/videos',
        queryParameters: {
          "page": page,
          if (categoryId != -1) "categoryId": categoryId,
          if (workoutLevel != null) "workout-level": workoutLevel,
          if (workoutLevel != null) "sort-by": sortBy,
        },
      );

      if (response.data != null) {
        final List<dynamic> listData = response.data['data'];
        final List<VideoModel> videos =
            listData.map((json) => VideoModel.fromJson(json)).toList();
        return Right(videos);
      } else {
        return const Left(Constants.channelNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> followChannel(int channelId) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.post,
        ApiUrls.follow,
        options: Options(headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        }),
        data: {
          Constants.channelId: channelId,
        },
      );
      if (response.data['statusCode'] == 201) {
        return const Right(Constants.success);
      } else {
        return const Left(Constants.failed);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> unFollowChannel(int channelId) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.delete,
        ApiUrls.follow,
        options: Options(headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        }),
        data: {
          Constants.channelId: channelId,
        },
      );
      if (response.data['statusCode'] == 200) {
        return const Right(Constants.success);
      } else {
        return const Left(Constants.failed);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }
}
