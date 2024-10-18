import 'package:dartz/dartz.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/services/api_service.dart';

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
      print("response.fail $e");

      return Left(e.toString());
    }
  }
}
