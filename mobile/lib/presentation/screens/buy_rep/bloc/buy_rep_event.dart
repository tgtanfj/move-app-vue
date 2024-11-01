import 'package:move_app/data/models/rep_model.dart';

sealed class BuyRepEvent {
  const BuyRepEvent();
}

final class BuyRepInitialEvent extends BuyRepEvent {
  final RepModel rep;

  BuyRepInitialEvent(this.rep);
}

final class BuyRepCardNameEvent extends BuyRepEvent {
  final String? cardName;

  const BuyRepCardNameEvent({required this.cardName});
}

final class BuyRepCountryEvent extends BuyRepEvent {
  final String? countryCode;

  const BuyRepCountryEvent({required this.countryCode});
}

final class BuyRepCardNumberEvent extends BuyRepEvent {
  final String? cardNumber;

  const BuyRepCardNumberEvent({required this.cardNumber});
}

final class BuyRepExpiryDateEvent extends BuyRepEvent {
  final String? expiryDate;

  const BuyRepExpiryDateEvent({required this.expiryDate});
}

final class BuyRepCvvEvent extends BuyRepEvent {
  final String? cvv;

  const BuyRepCvvEvent({required this.cvv});
}

final class BuyRepSavePaymentEvent extends BuyRepEvent {}

final class BuyRepPayNowEvent extends BuyRepEvent {}
