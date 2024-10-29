class PaymentMethodModel {
  final String paymentMethodId;

  PaymentMethodModel({
    required this.paymentMethodId,
  });

  Map<String, dynamic> toJson() => {
        'paymentMethodId': paymentMethodId,
      };

  @override
  String toString() => paymentMethodId;
}
