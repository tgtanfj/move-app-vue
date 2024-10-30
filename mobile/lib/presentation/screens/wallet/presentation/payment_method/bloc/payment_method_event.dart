sealed class PaymentMethodEvent {
  const PaymentMethodEvent();
}

final class PaymentMethodInitialEvent extends PaymentMethodEvent {
  const PaymentMethodInitialEvent();
}

final class PaymentMethodFetchDataEvent extends PaymentMethodEvent {
  const PaymentMethodFetchDataEvent();
}

final class PaymentMethodDetachCardEvent extends PaymentMethodEvent {
  final String? paymentMethodId;
  const PaymentMethodDetachCardEvent(this.paymentMethodId);
}
