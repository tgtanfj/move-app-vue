import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
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
    final parsed = ((responseBody['data'] is List) ? responseBody['data'] : [])
        .cast<Map<String, dynamic>>();
    return parsed.map<VideoModel>((json) => VideoModel.fromJson(json)).toList();
  }

  Future<Either<String, VideoModel>> getVideoDetail(
      {required int videoId}) async {
    try {
      final response = await ApiService().request(
        APIRequestMethod.get,
        'video/$videoId/details',
      );
      if (response.data != null) {
        final video = VideoModel.fromJson(response.data['data']);
        return Right(video);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<VideoModel>>> getListTrendVideo() async {
    try {
      final response = await ApiService().request(
        APIRequestMethod.get,
        ApiUrls.homeVideosTrendEndPoint,
      );
      if (response.data != null) {
        List<dynamic> videosJson = response.data['data'] as List<dynamic>;
        var videos =
            videosJson.map((json) => VideoModel.fromJson(json)).toList();
        return Right(videos);
      } else {
        return const Right([]);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<VideoModel>>> getListYouMayLikeVideo() async {
    try {
      String endpoint = ApiUrls.homeVideosYouMayLikeNoLoginEndPoint;
      if (SharedPrefer.sharedPrefer.getUserToken().isNotEmpty) {
        endpoint = ApiUrls.homeVideosYouMayLikeEndPoint;
      }
      final response =
          await ApiService().request(APIRequestMethod.get, endpoint);
      if (response.data != null) {
        List<dynamic> videosJson = response.data['data'] as List<dynamic>;
        var videos =
            videosJson.map((json) => VideoModel.fromJson(json)).toList();
        return Right(videos);
      } else {
        return const Right([]);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<VideoModel>>> getListVideoOfCategory(
      {required int categoryId, required int page, int? take}) async {
    try {
      String endpoint = ApiUrls.homeCategoriesNoLoginEndPoint;
      if (SharedPrefer.sharedPrefer.getUserToken().isNotEmpty) {
        endpoint = ApiUrls.homeCategoriesLoginEndPoint;
      }
      endpoint += categoryId.toString();
      take = take ?? 12;
      final response = await ApiService().request(
        APIRequestMethod.get,
        endpoint,
        queryParameters: {'page': page, 'take': take},
      );
      if (response.data != null) {
        List<dynamic> videosJson = response.data['data'] as List<dynamic>;
        var videos =
            videosJson.map((json) => VideoModel.fromJson(json)).toList();
        return Right(videos);
      } else {
        return const Left(Constants.videoNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
