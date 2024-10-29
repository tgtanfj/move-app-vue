import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/card_model.dart';
import 'package:move_app/data/models/card_payment_model.dart';

enum PaymentMethodStatus {
  initial,
  processing,
  success,
  failure,
}

final class PaymentMethodState extends Equatable {
  final PaymentMethodStatus? status;
  final String? errorMessage;
  final bool? isCardEmpty;
  final CardPaymentModel? cardPaymentModel;
  final CardModel? card;

  const PaymentMethodState({
    this.status,
    this.errorMessage,
    this.isCardEmpty,
    this.cardPaymentModel,
    this.card,
  });

  static PaymentMethodState initial() => const PaymentMethodState(
        status: PaymentMethodStatus.initial,
        errorMessage: '',
        isCardEmpty: false,
        cardPaymentModel: null,
        card: null,
      );

  PaymentMethodState copyWith({
    PaymentMethodStatus? status,
    String? errorMessage,
    bool? isCardEmpty,
    CardPaymentModel? cardPaymentModel,
    CardModel? card,
  }) {
    return PaymentMethodState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isCardEmpty: isCardEmpty ?? this.isCardEmpty,
      cardPaymentModel: cardPaymentModel ?? this.cardPaymentModel,
      card: card ?? this.card,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, isCardEmpty, cardPaymentModel, card];
}
