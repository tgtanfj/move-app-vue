import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/data/models/search_history_model.dart';

import '../../constants/api_urls.dart';
import '../../constants/constants.dart';
import '../data_sources/local/shared_preferences.dart';
import '../services/api_service.dart';

class SearchHistoryRepository {
  final ApiService apiService = ApiService();
  String accessToken = SharedPrefer.sharedPrefer.getUserToken();

  Future<Either<String, List<SearchHistoryModel>?>> getSearchHistory() async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchHistoryEndpoint,
        options: Options(
          headers: {
            'Accept': '/',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        final result = parseSearchHistory(response.data);
        return Right(result);
      } else {
        return const Left("Cannot load search history");
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

  List<SearchHistoryModel>? parseSearchHistory(
      Map<String, dynamic> responseBody) {
    final parsed = ((responseBody['data']['histories'] is List)
        ? responseBody['data']['histories']
        : [])
        .cast<Map<String, dynamic>>();

    return parsed
        .map<SearchHistoryModel>((json) => SearchHistoryModel.fromJson(json))
        .toList();
  }

  Future<Either<String, SearchHistoryModel?>> saveSearchHistory(
      SearchHistoryModel searchContent) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.post,
        ApiUrls.searchHistoryEndpoint,
        data: searchContent.toJson(),
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 201) {
        final result = parseSaveSearchHistory(response.data);
        return Right(result);
      } else {
        return const Left("save fail");
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

  SearchHistoryModel? parseSaveSearchHistory(
      Map<String, dynamic> responseBody) {
    final parsed = responseBody['data'] as Map<String, dynamic>;
    return SearchHistoryModel.fromJson(parsed);
  }

  Future<Either<String, String?>> deleteSearchHistory(
      SearchHistoryModel searchContent) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.delete,
        ApiUrls.searchHistoryEndpoint,
        queryParameters: searchContent.toJson(),
        options: Options(
          headers: {
            'Accept': '/',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        return const Right("Deleted successful");
      } else {
        return const Left("Cannot delete history");
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
