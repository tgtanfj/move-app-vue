import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/card_model.dart';
import 'package:move_app/data/models/card_payment_model.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/models/rep_model.dart';

enum PaymentMethodStatus { initial, processing, success, failure, removed }

final class PaymentMethodState extends Equatable {
  final PaymentMethodStatus? status;
  final String? errorMessage;
  final bool? isCardEmpty;
  final CardPaymentModel? cardPaymentModel;
  final PaymentMethodModel? paymentMethodModel;
  final CardModel? card;
  final bool? isRemoved;
  final RepModel? rep;

  const PaymentMethodState({
    this.status,
    this.errorMessage,
    this.isCardEmpty,
    this.cardPaymentModel,
    this.paymentMethodModel,
    this.card,
    this.isRemoved,
    this.rep,
  });

  static PaymentMethodState initial() => const PaymentMethodState(
        status: PaymentMethodStatus.initial,
        errorMessage: '',
        isCardEmpty: false,
        cardPaymentModel: null,
        paymentMethodModel: null,
        card: null,
        isRemoved: false,
      );

  PaymentMethodState copyWith({
    PaymentMethodStatus? status,
    String? errorMessage,
    bool? isCardEmpty,
    CardPaymentModel? cardPaymentModel,
    PaymentMethodModel? paymentMethodModel,
    CardModel? card,
    bool? isRemoved,
    RepModel? rep,
  }) {
    return PaymentMethodState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isCardEmpty: isCardEmpty ?? this.isCardEmpty,
      cardPaymentModel: cardPaymentModel ?? this.cardPaymentModel,
      paymentMethodModel: paymentMethodModel ?? this.paymentMethodModel,
      card: card ?? this.card,
      isRemoved: isRemoved ?? this.isRemoved,
      rep: rep ?? this.rep,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isCardEmpty,
        cardPaymentModel,
        card,
        paymentMethodModel,
        isRemoved,
        rep,
      ];
}
