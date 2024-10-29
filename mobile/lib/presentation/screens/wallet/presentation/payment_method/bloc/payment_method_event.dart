sealed class PaymentMethodEvent {
  const PaymentMethodEvent();
}

final class PaymentMethodInitialEvent extends PaymentMethodEvent {
  const PaymentMethodInitialEvent();
}

final class PaymentMethodFetchDataEvent extends PaymentMethodEvent {
  const PaymentMethodFetchDataEvent();

  @override
  List<Object> get props => [];
}
