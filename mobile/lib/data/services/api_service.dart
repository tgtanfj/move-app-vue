import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';

class ApiService {
  late Dio dio;

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {},
      contentType: "application/json: charset=utf-8",
      responseType: ResponseType.json,
    );
    dio = Dio(options);
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    var accessToken = SharedPrefer.sharedPrefer.getUserToken();
    if (accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};

    Map<String, dynamic>? authorization = getAuthorizationHeader();

    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    try {
      var response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: requestOptions,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};

    Map<String, dynamic>? authorization = getAuthorizationHeader();

    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    try {
      var response = await dio.post(path,
          data: data,
          queryParameters: queryParameters,
          options: requestOptions);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};

    Map<String, dynamic>? authorization = getAuthorizationHeader();

    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    try {
      var response = await dio.delete(
        path,
        queryParameters: queryParameters,
        options: requestOptions,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
