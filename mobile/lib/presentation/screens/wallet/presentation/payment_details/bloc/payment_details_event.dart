import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/wallet_argument_model.dart';

sealed class PaymentDetailsEvent {
  const PaymentDetailsEvent();
}

final class PaymentDetailsInitialEvent extends PaymentDetailsEvent {
  final CountryModel? selectedCountry;
  final WalletArguments? walletArguments;

  const PaymentDetailsInitialEvent(
      {this.selectedCountry, this.walletArguments});

  List<Object?> get props => [
        selectedCountry ?? 0,
        walletArguments,
      ];
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

class PaymentDetailsCardHolderNameEvent extends PaymentDetailsEvent {
  final String cardHolderName;

  const PaymentDetailsCardHolderNameEvent({required this.cardHolderName});

  List<Object?> get props => [cardHolderName];
}

class PaymentDetailsCardNumberEvent extends PaymentDetailsEvent {
  final String cardNumber;

  const PaymentDetailsCardNumberEvent({required this.cardNumber});

  List<Object?> get props => [cardNumber];
}

class PaymentDetailsExpiryDateEvent extends PaymentDetailsEvent {
  final String expiryDate;

  const PaymentDetailsExpiryDateEvent({required this.expiryDate});

  List<Object?> get props => [expiryDate];
}

class PaymentDetailsCvvEvent extends PaymentDetailsEvent {
  final String cvv;

  const PaymentDetailsCvvEvent({required this.cvv});

  List<Object?> get props => [cvv];
}
