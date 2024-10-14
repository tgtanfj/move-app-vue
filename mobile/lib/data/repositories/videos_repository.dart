import 'package:dartz/dartz.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/services/api_service.dart';

class VideosRepository {
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
}
