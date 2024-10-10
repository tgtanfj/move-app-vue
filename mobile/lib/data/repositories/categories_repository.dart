import 'dart:convert';

import 'package:dio/dio.dart';

import '../../constants/api_urls.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoriesRepository{
  Future<List<CategoryModel>> searchCategory(String query) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultCategory,
        options: Options(
          headers: {
            'Accept': '/',
            },
        ),
        queryParameters: {'q': query, 'limit': 10, 'page': 1},
      );
     if (response.statusCode == 200) {
        final result = parseSearchResultCategory(response.data);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<CategoryModel> parseSearchResultCategory(Map<String, dynamic> responseBody) {
    final parsed = ((responseBody['data'] is List)
        ? responseBody['data']
        : [])
        .cast<Map<String, dynamic>>();

    return parsed
        .map<CategoryModel>((json) => CategoryModel.fromJson(json))
        .toList();
  }
}