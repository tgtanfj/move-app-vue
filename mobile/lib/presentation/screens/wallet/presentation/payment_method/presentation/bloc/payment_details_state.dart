import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/country_model.dart';

enum PaymentDetailsStatus {
  initial,
  processing,
  success,
  failure,
  editUserSuccess,
}

final class PaymentDetailsState extends Equatable {
  final PaymentDetailsStatus? status;
  final String? errorMessage;
  final bool? showCardHolder;
  final List<CountryModel> countryList;
  final CountryModel? selectedCountry;
  final bool isShowCountryMessage;
  final String messageSelectCountry;
  final String? cardHolderName;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final String? paymentMethodId;
  final dynamic responseData;

  const PaymentDetailsState({
    this.status,
    this.errorMessage,
    this.showCardHolder,
    required this.countryList,
    this.messageSelectCountry = '',
    this.isShowCountryMessage = false,
    this.selectedCountry,
    this.cardHolderName,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.paymentMethodId,
    this.responseData,
  });

  static PaymentDetailsState initial() => const PaymentDetailsState(
        status: PaymentDetailsStatus.initial,
        errorMessage: '',
        showCardHolder: false,
        countryList: [],
        isShowCountryMessage: false,
        messageSelectCountry: '',
        selectedCountry: null,
        cardHolderName: '',
        cardNumber: '',
        expiryDate: '',
        cvv: '',
        paymentMethodId: '',
        responseData: null,
      );

  PaymentDetailsState copyWith({
    PaymentDetailsStatus? status,
    String? errorMessage,
    bool? showCardHolder,
    List<CountryModel>? countryList,
    CountryModel? selectedCountry,
    String? messageSelectCountry,
    bool? isShowCountryMessage,
    String? cardHolderName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? paymentMethodId,
    dynamic responseData,
  }) {
    return PaymentDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      showCardHolder: showCardHolder ?? this.showCardHolder,
      countryList: countryList ?? this.countryList,
      messageSelectCountry: messageSelectCountry ?? this.messageSelectCountry,
      isShowCountryMessage: isShowCountryMessage ?? this.isShowCountryMessage,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      responseData: responseData ?? this.responseData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        showCardHolder,
        countryList,
        messageSelectCountry,
        isShowCountryMessage,
        selectedCountry,
        cardHolderName,
        cardNumber,
        expiryDate,
        cvv,
        responseData,
        paymentMethodId
      ];
}
