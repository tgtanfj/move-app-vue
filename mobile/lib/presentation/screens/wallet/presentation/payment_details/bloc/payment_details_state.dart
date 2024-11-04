import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/wallet_argument_model.dart';
import 'package:move_app/utils/card_number_formatter.dart';

enum PaymentDetailsStatus {
  initial,
  processing,
  success,
  failure,
  editUserSuccess,
  added,
}

final class PaymentDetailsState extends Equatable {
  final PaymentDetailsStatus? status;
  final String? errorMessage;
  final bool? showCardHolder;
  final List<CountryModel> countryList;
  final CountryModel? selectedCountry;
  final String messageSelectCountry;
  final String? cardHolderName;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final bool? isShowCardHolderNameMessage;
  final bool? isShowCardNumberMessage;
  final bool? isShowExpiryDateMessage;
  final bool? isShowCvvMessage;
  final String? cardHolderNameErrorMessage;
  final String? cardNumberErrorMessage;
  final String? expiryDateErrorMessage;
  final String? cvvErrorMessage;
  final String? paymentMethodId;
  final dynamic responseData;
  final CardType cardType;
  final WalletArguments? walletArguments;

  bool get isEnableSubmitPaymentMethod =>
      (cardHolderName?.isNotEmpty ?? false) &&
      (cardNumber?.isNotEmpty ?? false) &&
      (expiryDate?.isNotEmpty ?? false) &&
      (cvv?.isNotEmpty ?? false);

  const PaymentDetailsState({
    this.status,
    this.errorMessage,
    this.showCardHolder,
    required this.countryList,
    this.messageSelectCountry = '',
    this.selectedCountry,
    this.cardHolderName,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.isShowCardHolderNameMessage,
    this.isShowCardNumberMessage,
    this.isShowExpiryDateMessage,
    this.isShowCvvMessage,
    this.cardHolderNameErrorMessage,
    this.cardNumberErrorMessage,
    this.expiryDateErrorMessage,
    this.cvvErrorMessage,
    this.paymentMethodId,
    this.responseData,
    this.cardType = CardType.unknown,
    this.walletArguments,
  });

  static PaymentDetailsState initial() => const PaymentDetailsState(
        status: PaymentDetailsStatus.initial,
        errorMessage: '',
        showCardHolder: false,
        countryList: [],
        messageSelectCountry: '',
        selectedCountry: null,
        cardHolderName: '',
        cardNumber: '',
        expiryDate: '',
        cvv: '',
        isShowCardHolderNameMessage: false,
        isShowCardNumberMessage: false,
        isShowExpiryDateMessage: false,
        isShowCvvMessage: false,
        cardHolderNameErrorMessage: '',
        cardNumberErrorMessage: '',
        expiryDateErrorMessage: '',
        cvvErrorMessage: '',
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
    String? cardHolderName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    bool? isShowCardHolderNameMessage,
    bool? isShowCardNumberMessage,
    bool? isShowExpiryDateMessage,
    bool? isShowCvvMessage,
    String? cardHolderNameErrorMessage,
    String? cardNumberErrorMessage,
    String? expiryDateErrorMessage,
    String? cvvErrorMessage,
    String? paymentMethodId,
    dynamic responseData,
    CardType? cardType,
    WalletArguments? walletArguments,
  }) {
    return PaymentDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      showCardHolder: showCardHolder ?? this.showCardHolder,
      countryList: countryList ?? this.countryList,
      messageSelectCountry: messageSelectCountry ?? this.messageSelectCountry,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isShowCardHolderNameMessage:
          isShowCardHolderNameMessage ?? this.isShowCardHolderNameMessage,
      isShowCardNumberMessage:
          isShowCardNumberMessage ?? this.isShowCardNumberMessage,
      isShowExpiryDateMessage:
          isShowExpiryDateMessage ?? this.isShowExpiryDateMessage,
      isShowCvvMessage: isShowCvvMessage ?? this.isShowCvvMessage,
      cardHolderNameErrorMessage:
          cardHolderNameErrorMessage ?? this.cardHolderNameErrorMessage,
      cardNumberErrorMessage:
          cardNumberErrorMessage ?? this.cardNumberErrorMessage,
      expiryDateErrorMessage:
          expiryDateErrorMessage ?? this.expiryDateErrorMessage,
      cvvErrorMessage: cvvErrorMessage ?? this.cvvErrorMessage,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      responseData: responseData ?? this.responseData,
      cardType: cardType ?? this.cardType,
      walletArguments: walletArguments ?? this.walletArguments,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        showCardHolder,
        countryList,
        messageSelectCountry,
        selectedCountry,
        cardHolderName,
        cardNumber,
        expiryDate,
        cvv,
        isShowCardHolderNameMessage,
        isShowCardNumberMessage,
        isShowExpiryDateMessage,
        isShowCvvMessage,
        cardHolderNameErrorMessage,
        cardNumberErrorMessage,
        expiryDateErrorMessage,
        cvvErrorMessage,
        responseData,
        paymentMethodId,
        cardType,
        walletArguments,
      ];
}
