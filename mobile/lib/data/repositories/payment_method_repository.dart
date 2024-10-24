import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/services/api_service.dart';

class PaymentMethodRepository {
  final ApiService apiService = ApiService();

  Future<Either<String, Response>> postAddPaymentMethod(
      PaymentMethodModel paymentMethodModel) async {
    try {
      final Response response = await apiService.request(
        APIRequestMethod.post,
        ApiUrls.addPaymentEndpoint,
        data: paymentMethodModel.toJson(),
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
      print(" hihihahahaa ${response.data}");
      if (response.statusCode == 200) {
        print("object ${response.data}");
        return Right(response);
      } else {
        return Left("${response.statusCode}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }
}
