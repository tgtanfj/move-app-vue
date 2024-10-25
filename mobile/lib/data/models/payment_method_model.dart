class PaymentMethodModel {
  final String paymentMethodId;

  PaymentMethodModel({
    required this.paymentMethodId,
  });

  Map<String, dynamic> toJson() => {
        'id': paymentMethodId,
      };

  @override
  String toString() => 'PaymentMethodModel(paymentMethodId: $paymentMethodId)';
}
