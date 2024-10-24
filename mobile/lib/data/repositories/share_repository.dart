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
        return const Left('Cannot sharing Video');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage =
            errorData['message'] ?? Constants.unknownErrorOccurred;
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }
}
