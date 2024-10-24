import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService() {
    Stripe.publishableKey =
        'pk_test_51Q27my2L2Kmk6amTSipMaRwGvSmmYvRPJ4zaOkeZilHJ1bfG1zw8UAczBj1JkM9XPfDvTiHIEJMZTxmqu8YrMQRx003JqX6eIZ';
  }

  Future<void> createPaymentMethod({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolderName,
    required String country,
    String? city,
    String? line1,
    String? line2,
    String? postalCode,
    String? state,
  }) async {
    try {
      // final expiryDateParts = expiryDate.split('/');
      // final expiryMonth = int.parse(expiryDateParts[0]);
      // final expiryYear = int.parse(expiryDateParts[1]);

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: cardHolderName,
              address: Address(
                country: country,
                city: city,
                line1: line1,
                line2: line2,
                postalCode: postalCode,
                state: state,
              ),
            ),
            // card: CardFieldInputDetails(
            //   number: cardNumber,
            //   expiryMonth: expiryMonth,
            //   expiryYear: expiryYear,
            //   cvc: cvv,
            //   complete: true,
            // ),
          ),
        ),
      );

      print('Payment method created: ${paymentMethod.id}');
    } catch (e) {
      throw Exception('Unable to create payment method: $e');
    }
  }
}
