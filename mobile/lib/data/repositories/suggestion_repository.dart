import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/data/models/suggestion_model.dart';

import '../../constants/api_urls.dart';
import '../../constants/constants.dart';
import '../services/api_service.dart';

class SuggestionRepository {
  Future<Either<String, SuggestionModel?>> searchSuggestion(
      String query) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.suggestionEndpoint,
        queryParameters: {'q': query},
      );
      if (response.statusCode == 200) {
        final result = parseSuggestion(response.data);
        return Right(result);
      } else {
        return const Left('Cannot load suggestion');
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

  SuggestionModel? parseSuggestion(Map<String, dynamic> responseBody) {
    final suggestionJson = responseBody['data'] as Map<String, dynamic>;
    return SuggestionModel.fromJson(suggestionJson);
  }
}
