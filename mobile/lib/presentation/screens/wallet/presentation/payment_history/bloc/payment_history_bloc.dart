import 'package:bloc/bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc() : super(PaymentHistoryState.initial()) {
    on<PaymentHistoryInitialEvent>(_onPaymentHistoryInitialEvent);
    on<PaymentHistorySelectionStartDateEvent>(
        _onPaymentHistorySelectionStartDateEvent);
    on<PaymentHistorySelectionEndDateEvent>(
        _onPaymentHistorySelectionEndDateEvent);
  }

  void _onPaymentHistoryInitialEvent(
      PaymentHistoryInitialEvent event, Emitter<PaymentHistoryState> emit) {}

  void _onPaymentHistorySelectionStartDateEvent(
      PaymentHistorySelectionStartDateEvent event,
      Emitter<PaymentHistoryState> emit) {
    emit(state.copyWith(
      isPickedStartDate: !(state.isPickedStartDate ?? false),
      isPickedEndDate: false,
      startDate: event.startDate,
    ));
  }

  void _onPaymentHistorySelectionEndDateEvent(
      PaymentHistorySelectionEndDateEvent event,
      Emitter<PaymentHistoryState> emit) {
    emit(state.copyWith(
      isPickedEndDate: !(state.isPickedEndDate ?? false),
      isPickedStartDate: false,
      endDate: event.endDate,
    ));
  }
}
