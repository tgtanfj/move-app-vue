import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:move_app/constants/api_urls.dart';

enum Method { get, post, put, delete, patch }

class ApiServiceAdditional {
  late Dio dio;

  static final ApiServiceAdditional _instance = ApiServiceAdditional._internal();

  factory ApiServiceAdditional() {
    return _instance;
  }

  ApiServiceAdditional._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: "application/json: charset=utf-8",
      responseType: ResponseType.json,
    ));
  }

  Future<Response<T>> request<T>(
      Method method,
      String path, {
        Map<String, dynamic>? queryParameters,
        Object? data,
        Options? options,
      }) async {
    try {
      Response<T> response;
      switch (method) {
        case Method.get:
          response = await dio.get<T>(path,
              queryParameters: queryParameters, options: options);
          break;
        case Method.post:
          response = await dio.post<T>(path, data: data, options: options, queryParameters: queryParameters);
          break;
        case Method.put:
          response = await dio.put<T>(path, data: data, options: options);
          break;
        case Method.delete:
          response = await dio.delete<T>(path,
              queryParameters: queryParameters, options: options);
          break;
        case Method.patch:
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
