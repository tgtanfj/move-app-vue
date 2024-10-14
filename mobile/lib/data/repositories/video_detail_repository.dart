import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';
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
      return Left(e.toString());
    }
  }
}
