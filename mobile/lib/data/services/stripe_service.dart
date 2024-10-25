import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  // StripeService() {
  //   Stripe.publishableKey =
  //       'pk_test_51Q27my2L2Kmk6amTSipMaRwGvSmmYvRPJ4zaOkeZilHJ1bfG1zw8UAczBj1JkM9XPfDvTiHIEJMZTxmqu8YrMQRx003JqX6eIZ';
  // }

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
    try {
      // final expiryDateParts = expiryDate.split('/');
      // final expiryMonth = int.parse(expiryDateParts[0]);
      // final expiryYear = int.parse(expiryDateParts[1]);

      print('Creating payment method with card number: $cardNumber');
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
          options: const PaymentMethodOptions(
            setupFutureUsage: PaymentIntentsFutureUsage.OnSession,
          ));
      print("objectttttttttttttttttt ${paymentMethod.toJson()}");

      print('Payment method created: ${paymentMethod.id}');

      // Sau khi tạo phương thức thanh toán thành công, gửi thông tin lên server
      // final paymentMethodModel = PaymentMethodModel(
      //   paymentMethodId: paymentMethod.id,
      // );

      // final result = await PaymentMethodRepository()
      //     .postAddPaymentMethod(paymentMethodModel);

      // result.fold(
      //   (failure) => print('Failed to send payment method: $failure'),
      //   (response) =>
      //       print('Payment method successfully sent: ${response.data}'),
      // );
      return paymentMethod;
    } catch (e) {
      print('Error occurred while creating payment method: $e');
      throw Exception('Unable to create payment method: $e');
    }
  }
}
