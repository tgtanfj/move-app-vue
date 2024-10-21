import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../constants/api_urls.dart';
import '../../constants/constants.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoriesRepository {
  Future<Either<String, List<CategoryModel>>> searchCategory(
      String query, int page) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultCategory,
        queryParameters: {'q': query, 'limit': 1, 'page': page},
      );
      if (response.statusCode == 200) {
        final result = parseSearchResultCategory(response.data);
        return Right(result);
      } else {
        return const Left("Cannot load Category");
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

  List<CategoryModel> parseSearchResultCategory(
      Map<String, dynamic> responseBody) {
    final parsed = ((responseBody['data'] is List) ? responseBody['data'] : [])
        .cast<Map<String, dynamic>>();

    return parsed
        .map<CategoryModel>((json) => CategoryModel.fromJson(json))
        .toList();
  }

  Future<Either<String, int?>> getTotalCategoriesPages(
      String query, int page) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultCategory,
        queryParameters: {'q': query, 'limit': 1, 'page': page},
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

  Future<Either<String, List<CategoryModel>>> getListTopCategory() async {
    try {
      final response = await ApiService().request(
        APIRequestMethod.get,
        ApiUrls.homeTopCategoriesEndPoint,
      );
      if (response.data != null) {
        List<dynamic> categoriesJson = response.data['data'] as List<dynamic>;
        var categories =
            categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
        return Right(categories);
      } else {
        return const Right([]);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
  
}
