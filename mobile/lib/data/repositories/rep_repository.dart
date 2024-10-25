import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/data/services/api_service.dart';
import 'package:move_app/data/services/stripe_service.dart';

class RepRepository {
  final ApiService apiService = ApiService();
  final StripeService stripeService = StripeService();

  Future<Either<String, List<RepModel>>> getListRep() async {
    try {
      final response = await apiService.request(
          APIRequestMethod.get, ApiUrls.paymentListRepsPackageEndPoint);
      if (response.data != null) {
        List<dynamic> repsJson = response.data['data'] as List<dynamic>;
        var reps = repsJson.map((json) => RepModel.fromJson(json)).toList();
        return Right(reps);
      } else {
        return const Left(Constants.repsNotFound);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> buyReps({
    required int repPackageId,
    required String paymentMethodId,
    bool? save,
  }) async {
    try {
      final data = {
        "repPackageId": repPackageId,
        "paymentMethodId": paymentMethodId,
      };

      if (save != null) {
        data["save"] = save;
      }

      final response = await apiService.request(
        APIRequestMethod.post,
        ApiUrls.paymentBuyRepsEndPoint,
        options: Options(
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );
      if (response.data['statusCode'] == 200) {
        var clientSecret = response.data['data']['client_secret'];
        if (response.data['data']['status'] == Constants.requiresConfirmation) {
          var paymentMethod = await stripeService.confirmPayment(
              paymentIntentClientSecret: clientSecret);
          print('Confirm payment method: ${paymentMethod.id}');
        }
        if (clientSecret != null) {
          return const Right(Constants.success);
        } else {
          return const Left(Constants.failed);
        }
      } else {
        return const Left(Constants.failed);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
