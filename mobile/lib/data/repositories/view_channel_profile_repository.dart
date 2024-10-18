import 'package:dartz/dartz.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/channel_model.dart';
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
}
