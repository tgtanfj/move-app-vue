import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/payment_method_repository.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final PaymentMethodRepository paymentMethodRepository =
      PaymentMethodRepository();
  PaymentMethodBloc() : super(PaymentMethodState.initial()) {
    on<PaymentMethodInitialEvent>(_onPaymentMethodInitialEvent);
    on<PaymentMethodFetchDataEvent>(_onPaymentMethodFetchDataEvent);
  }

  Future<void> _onPaymentMethodInitialEvent(
      PaymentMethodInitialEvent event, Emitter<PaymentMethodState> emit) async {
    emit(PaymentMethodState.initial());
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
}
