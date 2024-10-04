import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:move_app/constants/api_urls.dart';

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
        var accessToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjQwLCJkZXZpY2VJZCI6IjY5Zjg3Yjg4LWJhNDQtNDZiYy05NTExLWY4YzMwN2E4Y2I2YSIsImlhdCI6MTcyODIxODE2MCwiZXhwIjoxNzI4MzA0NTYwfQ.inzyC4krHrTiHbVZkMyappWZU3P6OLNVnalt_yKi0u0';
        // SharedPrefer.sharedPrefer.getUserToken();
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
