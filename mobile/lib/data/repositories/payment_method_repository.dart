import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/card_payment_model.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/services/api_service.dart';

class PaymentMethodRepository {
  final ApiService apiService = ApiService();
  String accessToken = SharedPrefer.sharedPrefer.getUserToken();

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
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 201) {
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

  Future<Either<String, CardPaymentModel>> getCard() async {
    try {
      final response = await apiService.request(
          APIRequestMethod.get, ApiUrls.stripeListCardsEndPoint);
      if (response.data != null) {
        final paymentMethod = CardPaymentModel.fromJson(response.data['data']);
        return Right(paymentMethod);
      } else {
        return const Left(Constants.paymentMethodsNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
