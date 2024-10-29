import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  Future<PaymentMethod> createPaymentMethod({
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
    final expiryDateParts = expiryDate.split('/');
    final expiryMonth = int.parse(expiryDateParts[0]);
    final expiryYear = int.parse(expiryDateParts[1]);

    CardDetails card = CardDetails(
        number: cardNumber,
        cvc: cvv,
        expirationMonth: expiryMonth,
        expirationYear: expiryYear);
    await Stripe.instance.dangerouslyUpdateCardDetails(card);
    try {
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
            ),
          ),
          options: const PaymentMethodOptions(
            setupFutureUsage: PaymentIntentsFutureUsage.OnSession,
          ));

      print('Payment method created: ${paymentMethod.id}');
      return paymentMethod;
    } catch (e) {
      throw Exception('Unable to create payment method: $e');
    }
  }
}
