import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_event.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_state.dart';

class BuyRepBloc extends Bloc<BuyRepEvent, BuyRepState> {
  BuyRepBloc() : super(BuyRepState.initial()) {
    on<BuyRepInitialEvent>(_onBuyRepInitialEvent);
    on<BuyRepSavePaymentEvent>(_onBuyRepSavePaymentEvent);
  }

  void _onBuyRepInitialEvent(
      BuyRepInitialEvent event, Emitter<BuyRepState> emit) {}

  void _onBuyRepSavePaymentEvent(
      BuyRepSavePaymentEvent event, Emitter<BuyRepState> emit) {
    emit(state.copyWith(
      isSavePayment: !state.isSavePayment,
    ));
  }
}
