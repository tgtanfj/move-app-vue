import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/services/stripe_service.dart';

class StripeRepository {
  final StripeService stripeService = StripeService();

  Future<Either<String, String>> createPaymentMethod(
      {required String cardNumber,
      required String cardName,
      required String expiryDate,
      required String cvv,
      required String countryCode}) async {
    try {
      final response = await stripeService.createPaymentMethod(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cvv: cvv,
          cardHolderName: cardName,
          country: countryCode);
      return Right(response.id);
    } catch (e) {
      if (e is StripeException) {
        return Left(e.error.localizedMessage ?? Constants.unknownErrorOccurred);
      } else {
        return Left(e.toString());
      }
    }
  }
}
