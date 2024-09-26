import 'package:flutter_bloc/flutter_bloc.dart';

import 'dialog_authentication_event.dart';
import 'dialog_authentication_state.dart';


class DialogAuthenticationBloc
    extends Bloc<DialogAuthenticationEvent, DialogAuthenticationState> {
  DialogAuthenticationBloc() : super(const DialogAuthenticationState()) {
    on<ShowLoginPageEvent>(onShowLoginPageEvent);
  }

  void onShowLoginPageEvent(
      ShowLoginPageEvent event,
      Emitter<DialogAuthenticationState> emit,
      ) {
    emit(state.copyWith(isShowLoginPage: !state.isShowLoginPage));
  }
}