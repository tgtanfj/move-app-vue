import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/channel_model.dart';
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

  Future<Either<String, String>> followChannel(int channelId) async {
    print('ChannelID ---- $channelId');
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
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          print('EEEEE $errorData');
          final errorMessage =
              errorData['message'] ?? Constants.unknownErrorOccurred;
          print('MMM $errorMessage');

          return Left(errorMessage);
        } else {
          return Left(e.message.toString());
        }
      }
      return Left(e.toString());
    }
  }
}
