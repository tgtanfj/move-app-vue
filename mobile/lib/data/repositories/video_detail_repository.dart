import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/services/api_service.dart';

class VideoDetailRepository {
  final ApiService apiService = ApiService();

  Future<Either<String, int>> getRateByVideoId(int videoId) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        'watching-video-history/$videoId/rate',
      );
      if (response.data != null) {
        final rate = response.data['data']['rate'];
        return Right(rate);
      } else {
        return const Left(Constants.rateNotFound);
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

  Future<Either<String, int>> rateVideo(int videoId, int rate) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.patch,
        ApiUrls.rateVideo,
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          Constants.rateValue: rate,
          Constants.videoId: videoId,
        },
      );
      if (response.data != null) {
        final rate = response.data['data']['rate'];
        return Right(rate);
      } else {
        return const Left(Constants.rateNotFound);
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

  Future<Either<String, VideoModel>> getVideoDetail(int videoId) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        'video/$videoId/details',
      );
      if (response.data != null) {
        var videos = VideoModel.fromJson(response.data['data']);
        return Right(videos);
      } else {
        return const Left(Constants.videoNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
