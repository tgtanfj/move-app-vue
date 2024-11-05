import 'package:move_app/data/models/rep_model.dart';

sealed class PaymentMethodEvent {
  const PaymentMethodEvent();
}

final class PaymentMethodInitialEvent extends PaymentMethodEvent {
  final RepModel? rep;
  const PaymentMethodInitialEvent(this.rep);
}

final class PaymentMethodFetchDataEvent extends PaymentMethodEvent {
  const PaymentMethodFetchDataEvent();
}

final class PaymentMethodDetachCardEvent extends PaymentMethodEvent {
  final String? paymentMethodId;
  const PaymentMethodDetachCardEvent(this.paymentMethodId);
}
