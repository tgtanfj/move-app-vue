sealed class BuyRepEvent {
  const BuyRepEvent();
}

final class BuyRepInitialEvent extends BuyRepEvent {}

final class BuyRepSavePaymentEvent extends BuyRepEvent {
  BuyRepSavePaymentEvent();
}
