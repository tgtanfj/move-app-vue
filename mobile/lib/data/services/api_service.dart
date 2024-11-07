import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/repositories/auth_repository.dart';

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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          var accessToken = SharedPrefer.sharedPrefer.getUserToken();
          if (accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          var accessToken = SharedPrefer.sharedPrefer.getUserToken();
          if (error.response?.statusCode == 400 &&
              JwtDecoder.isExpired(accessToken)) {
            try {
              final respone = await refreshAccessToken();
              respone.fold((l) async {
                handler.next(error);
              }, (r) async {
                error.requestOptions.headers['Authorization'] = 'Bearer $r';
                final newResponse = await dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                return handler.resolve(newResponse);
              });
            } catch (e) {
              await AuthRepository().logOut();
              return handler.next(error);
            }
          } else {
            return handler.next(error);
          }
        },
      ),
    );
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
              data: data, queryParameters: queryParameters, options: options);
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

  Future<Either<String, String>> refreshAccessToken() async {
    try {
      String? refreshToken = SharedPrefer.sharedPrefer.getUserRefreshToken();
      if (refreshToken.isNotEmpty) {
        await SharedPrefer.sharedPrefer.setUserToken(refreshToken);
        final response = await ApiService().request(
          APIRequestMethod.get,
          ApiUrls.refreshTokenEndpoint,
        );
        if (response.statusCode == 200) {
          final newAccessToken = response.data['data']['accessToken'];
          await SharedPrefer.sharedPrefer.setUserToken(newAccessToken);
          return Right(newAccessToken);
        }
        if (response.statusCode == 400) {
          await AuthRepository().logOut();
        }
      }
      return const Left(Constants.refreshTokenExpired);
    } catch (e) {
      return const Left(Constants.refreshTokenExpired);
    }
  }
}
