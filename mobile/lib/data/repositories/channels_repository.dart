import 'dart:convert';

import 'package:dio/dio.dart';

import '../../constants/api_urls.dart';
import '../models/channel_model.dart';
import '../models/channel_search_model.dart';
import '../services/api_service.dart';

class ChannelsRepository{
  Future<List<ChannelModel>> searchChannel(String query, int page) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultChannel,
        queryParameters: {'q': query, 'limit':2, 'page': page},
      );
      if (response.statusCode == 200) {
        final result = parseSearchResultChannel(response.data);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<ChannelModel> parseSearchResultChannel(Map<String, dynamic> responseBody) {
    final parsed = ((responseBody['data'] is List)
        ? responseBody['data']
        : [])
        .cast<Map<String, dynamic>>();
    return parsed
        .map<ChannelModel>((json) => ChannelModel.fromJson(json))
        .toList();
  }

  Future<int?> getTotalPages(String query, int page) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.searchResultChannel,
        queryParameters: {'q': query, 'limit': 2, 'page': page},
      );
      if (response.statusCode == 200) {
        final result = response.data['meta'];
        final totalPages = result['totalPages'];
        return totalPages;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}