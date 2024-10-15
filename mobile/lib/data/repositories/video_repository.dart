import 'package:dartz/dartz.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/services/api_service.dart';

class VideoRepository {
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
}
