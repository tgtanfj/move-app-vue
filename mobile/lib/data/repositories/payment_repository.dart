import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/data/models/payment_model.dart';

import '../../constants/api_urls.dart';
import '../../constants/constants.dart';
import '../services/api_service.dart';

class PaymentRepository {
  final ApiService apiService = ApiService();

  Future<Either<String, List<PaymentModel>>> getPaymentHistory(
      PaymentModel paymentModel) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.paymentHistory,
        queryParameters: paymentModel.toJson(),
      );
      if (response.statusCode == 200) {
        final result = parsePaymentHistory(response.data);
        return Right(result);
      } else {
        return const Left(Constants.noPaymentHistory);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage =
            errorData['message'] ?? Constants.unknownErrorOccurred;
        return Left(errorMessage);
      } else {
        return Left(e.toString());
      }
    }
  }

  List<PaymentModel> parsePaymentHistory(Map<String, dynamic> responseBody) {
    final parsed = ((responseBody['data'] is List) ? responseBody['data'] : [])
        .cast<Map<String, dynamic>>();
    return parsed
        .map<PaymentModel>((json) => PaymentModel.fromJson(json))
        .toList();
  }

  Future<Either<String, PaymentModel?>> getTotalPaymentHistoryPages(
      PaymentModel paymentModel) async {
    try {
      final response = await apiService.request(
        APIRequestMethod.get,
        ApiUrls.paymentHistory,
        queryParameters: paymentModel.toJson(),
      );
      if (response.statusCode == 200) {
        final result = response.data['meta'];
        final total = PaymentModel.fromJson(result);
        return Right(total);
      } else {
        return const Left(Constants.cannotGetTotalPage);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        final errorMessage =
            errorData['message'] ?? Constants.unknownErrorOccurred;
        return Left(errorMessage);
      }
      return Left(e.toString());
    }
  }
}
