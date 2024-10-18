import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../constants/api_urls.dart';
import '../../constants/constants.dart';
import '../models/channel_model.dart';
import '../services/api_service.dart';

class ChannelsRepository {
  Future<Either<String, List<ChannelModel>>> searchChannel(
      String query, int page) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultChannel,
        queryParameters: {'q': query, 'limit': 8, 'page': page},
      );
      if (response.statusCode == 200) {
        final result = parseSearchResultChannel(response.data);
        return Right(result);
      } else {
        return const Left("Cannot load channel");
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

  List<ChannelModel> parseSearchResultChannel(
      Map<String, dynamic> responseBody) {
    final parsed = ((responseBody['data'] is List) ? responseBody['data'] : [])
        .cast<Map<String, dynamic>>();
    return parsed
        .map<ChannelModel>((json) => ChannelModel.fromJson(json))
        .toList();
  }

  Future<Either<String, int?>> getTotalPages(String query, int page) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultChannel,
        queryParameters: {'q': query, 'limit': 8, 'page': page},
      );
      if (response.statusCode == 200) {
        final result = response.data['meta'];
        final totalPages = result['totalPages'];
        return Right(totalPages);
      } else {
        return const Left("Cannot get total pages");
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
}
