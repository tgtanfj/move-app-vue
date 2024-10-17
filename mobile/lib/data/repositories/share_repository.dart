import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../constants/api_urls.dart';
import '../../constants/constants.dart';
import '../services/api_service.dart';

class ShareRepository {
  Future<Either<String, String?>> sharingVideo(
      int? videoId, String? option) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        '${ApiUrls.sharingVideoEndPoint}/$videoId',
        queryParameters: {'option': option},
      );
      if (response.statusCode == 200) {
        final result = response.data['data'];
        return Right(result);
      } else {
        return const Left('cannot sharing Video');
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
