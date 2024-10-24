import 'package:move_app/data/models/country_model.dart';

sealed class PaymentDetailsEvent {
  const PaymentDetailsEvent();
}

final class PaymentDetailsInitialEvent extends PaymentDetailsEvent {
  final CountryModel? selectedCountry;

  const PaymentDetailsInitialEvent({this.selectedCountry});

  List<Object?> get props => [selectedCountry ?? 0];
}

final class PaymentDetailsSubmitEvent extends PaymentDetailsEvent {
  final String paymentMethodId;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvv;
  final String cardType;
  final String country;

  const PaymentDetailsSubmitEvent(
      {required this.paymentMethodId,
      required this.cardNumber,
      required this.expiryDate,
      required this.cardHolderName,
      required this.cvv,
      this.cardType = 'visa',
      required this.country});

  List<Object?> get props => [
        cardNumber,
        expiryDate,
        cardHolderName,
        cvv,
        cardType,
        country,
        paymentMethodId
      ];
}

class PaymentDetailsCountrySelectEvent extends PaymentDetailsEvent {
  final int? countryId;
  final CountryModel? selectedCountry;

  const PaymentDetailsCountrySelectEvent(
      {this.countryId, this.selectedCountry});

  List<Object?> get props => [countryId ?? 0, selectedCountry ?? 0];
}
