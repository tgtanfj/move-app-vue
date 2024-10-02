import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/services/api_service.dart';

class ForgotPasswordRepository {
  final ApiService _apiService = ApiService();

  // Check if the email exists

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _apiService.request(
        APIRequestMethod.post,
        ApiUrls.forgotPasswordEndpoint,
        data: {"email": email},
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      // await SharedPrefer.sharedPrefer
      //     .setUserToken(response.data['data']['token']);
      if (response.data['success'] != null) return true;

      return false;
    } catch (e) {
      print('Error checking email: $e');
      return false;
    }
  }

  // Send reset password link
  Future<Either<String, bool>> sendResetPasswordLink(
      String token, String newPassword) async {
    try {
      final response = await _apiService.request(
        APIRequestMethod.post,
        ApiUrls.resetPasswordEndpoint,
        data: {'token': token, 'newPassword': newPassword},
        options: Options(
          headers: {
            'Accept': '/',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data['success'] != null) {
        return const Right(true);
      } else {
        return Left(
            'Error: ${response.statusCode}, Message: ${response.data['message']}');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
