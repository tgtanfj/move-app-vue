import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/card_payment_model.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/utils/card_number_formatter.dart';

enum BuyRepStatus {
  initial,
  processing,
  success,
  failure,
  orderSuccess,
  orderFailed,
  orderProcessing,
}

final class BuyRepState extends Equatable {
  final BuyRepStatus? status;
  final bool isSavePayment;
  final RepModel? rep;
  final CardPaymentModel? cardPaymentMethod;
  final String? errorMessage;
  final List<CountryModel>? countries;
  final String? cardName;
  final String? countryCode;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final PaymentMethodModel? paymentMethodModel;
  final String messageInputCardName;
  final String messageInputCardNumber;
  final String messageInputExpiryDate;
  final String messageInputCvv;
  final bool isShowCardNameMessage;
  final bool isShowCardNumberMessage;
  final bool isShowExpiryDateMessage;
  final bool isShowCvvMessage;
  final CardType cardType;

  const BuyRepState({
    this.status,
    this.isSavePayment = false,
    this.rep,
    this.cardPaymentMethod,
    this.errorMessage,
    this.countries,
    this.cardName,
    this.countryCode,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.paymentMethodModel,
    this.messageInputCardName = '',
    this.messageInputCardNumber = '',
    this.messageInputExpiryDate = '',
    this.messageInputCvv = '',
    this.isShowCardNameMessage = false,
    this.isShowCardNumberMessage = false,
    this.isShowExpiryDateMessage = false,
    this.isShowCvvMessage = false,
    this.cardType = CardType.unknown,
  });

  static BuyRepState initial() => const BuyRepState(
        status: BuyRepStatus.initial,
      );

  BuyRepState copyWith({
    BuyRepStatus? status,
    bool? isSavePayment,
    RepModel? rep,
    CardPaymentModel? cardPaymentMethod,
    String? errorMessage,
    List<CountryModel>? countries,
    String? cardName,
    String? countryCode,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    bool? isEnablePayNow,
    PaymentMethodModel? paymentMethodModel,
    String? messageInputCardName,
    String? messageInputCardNumber,
    String? messageInputExpiryDate,
    String? messageInputCvv,
    String? messageInputCountry,
    bool? isShowCardNameMessage,
    bool? isShowCardNumberMessage,
    bool? isShowExpiryDateMessage,
    bool? isShowCvvMessage,
    bool? isShowCountryMessage,
    CardType? cardType,
  }) {
    return BuyRepState(
      status: status ?? this.status,
      isSavePayment: isSavePayment ?? this.isSavePayment,
      rep: rep ?? this.rep,
      cardPaymentMethod: cardPaymentMethod ?? this.cardPaymentMethod,
      errorMessage: errorMessage ?? this.errorMessage,
      countries: countries ?? this.countries,
      cardName: cardName ?? this.cardName,
      countryCode: countryCode ?? this.countryCode,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      paymentMethodModel: paymentMethodModel ?? this.paymentMethodModel,
      messageInputCardName: messageInputCardName ?? this.messageInputCardName,
      messageInputCardNumber:
          messageInputCardNumber ?? this.messageInputCardNumber,
      messageInputExpiryDate:
          messageInputExpiryDate ?? this.messageInputExpiryDate,
      messageInputCvv: messageInputCvv ?? this.messageInputCvv,
      isShowCardNameMessage:
          isShowCardNameMessage ?? this.isShowCardNameMessage,
      isShowCardNumberMessage:
          isShowCardNumberMessage ?? this.isShowCardNumberMessage,
      isShowExpiryDateMessage:
          isShowExpiryDateMessage ?? this.isShowExpiryDateMessage,
      isShowCvvMessage: isShowCvvMessage ?? this.isShowCvvMessage,
      cardType: cardType ?? this.cardType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isSavePayment,
        rep,
        cardPaymentMethod,
        errorMessage,
        countries,
        cardName,
        cardNumber,
        countryCode,
        expiryDate,
        cvv,
        paymentMethodModel,
        messageInputCardName,
        messageInputCardNumber,
        messageInputExpiryDate,
        messageInputCvv,
        isShowCardNameMessage,
        isShowCardNumberMessage,
        isShowExpiryDateMessage,
        isShowCvvMessage,
        cardType,
      ];

  bool get isEnablePayNow =>
      (cardName?.isNotEmpty ?? false) &&
      (cardNumber?.isNotEmpty ?? false) &&
      (expiryDate?.isNotEmpty ?? false) &&
      (cvv?.isNotEmpty ?? false);
}
