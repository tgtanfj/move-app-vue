import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/repositories/payment_method_repository.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final PaymentMethodRepository paymentMethodRepository =
      PaymentMethodRepository();
  PaymentMethodBloc() : super(PaymentMethodState.initial()) {
    on<PaymentMethodInitialEvent>(_onPaymentMethodInitialEvent);
    on<PaymentMethodFetchDataEvent>(_onPaymentMethodFetchDataEvent);
    on<PaymentMethodDetachCardEvent>(_onPaymentMethodDetachCardEvent);
  }

  Future<void> _onPaymentMethodInitialEvent(
      PaymentMethodInitialEvent event, Emitter<PaymentMethodState> emit) async {
    emit(PaymentMethodState.initial());
    add(const PaymentMethodFetchDataEvent());
  }

  Future<void> _onPaymentMethodFetchDataEvent(PaymentMethodFetchDataEvent event,
      Emitter<PaymentMethodState> emit) async {
    emit(state.copyWith(status: PaymentMethodStatus.processing));
    final paymentMethod = await paymentMethodRepository.getCard();
    paymentMethod.fold(
        (error) => emit(state.copyWith(status: PaymentMethodStatus.failure)),
        (card) => emit(state.copyWith(
              status: PaymentMethodStatus.success,
              cardPaymentModel: card,
            )));
  }

  Future<void> _onPaymentMethodDetachCardEvent(
      PaymentMethodDetachCardEvent event,
      Emitter<PaymentMethodState> emit) async {
    if ((event.paymentMethodId ?? '').isEmpty) return;
    emit(state.copyWith(status: PaymentMethodStatus.processing));

    final paymentMethodModel =
        PaymentMethodModel(paymentMethodId: event.paymentMethodId!);
    final paymentMethod =
        await paymentMethodRepository.postDetachCard(paymentMethodModel);
    paymentMethod.fold(
        (error) => emit(state.copyWith(status: PaymentMethodStatus.failure)),
        (card) => emit(state.copyWith(
              status: PaymentMethodStatus.removed,
              card: null,
            )));
  }
}
