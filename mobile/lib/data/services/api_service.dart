import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';

enum APIRequestMethod { get, post, put, delete, patch }

class ApiService {
  late Dio dio;

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: "application/json: charset=utf-8",
      responseType: ResponseType.json,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        var accessToken = SharedPrefer.sharedPrefer.getUserToken();
        if (accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Response<T>> request<T>(
    APIRequestMethod method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
  }) async {
    try {
      Response<T> response;
      switch (method) {
        case APIRequestMethod.get:
          response = await dio.get<T>(path,
              queryParameters: queryParameters, options: options);
          break;
        case APIRequestMethod.post:
          response = await dio.post<T>(path,
              data: data, options: options, queryParameters: queryParameters);
          break;
        case APIRequestMethod.put:
          response = await dio.put<T>(path, data: data, options: options);
          break;
        case APIRequestMethod.delete:
          response = await dio.delete<T>(path,
              queryParameters: queryParameters, options: options);
          break;
        case APIRequestMethod.patch:
          response = await dio.patch<T>(path, data: data, options: options);
          break;
        default:
          throw Exception("Unsupported request method");
      }

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data is String) {
          throw Exception('Error: ${response.data}');
        }
        return response;
      } else {
        throw Exception(
            'Error: ${response.statusCode}, Message: ${response.statusMessage}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
