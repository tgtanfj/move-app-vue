import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/data/repositories/rep_repository.dart';
import 'package:move_app/data/repositories/user_repository.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_event.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_state.dart';

import '../../../../data/models/user_model.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState.initial()) {
    on<MenuInitialEvent>(_onMenuInitialEvent);
    on<MenuSelectMoreEvent>(_onMenuSelectMoreEvent);
    on<MenuLogoutSuccessEvent>(_onMenuLogoutSuccessEvent);
  }

  final userRepository = UserRepository();
  final RepRepository repository = RepRepository();

  void _onMenuInitialEvent(
      MenuInitialEvent event, Emitter<MenuState> emit) async {
    String token = SharedPrefer.sharedPrefer.getUserToken();

    if (token.isNotEmpty) {
      final result = await Future.wait([
        userRepository.getUserProfile(),
        repository.getListRep(),
      ]);
      (result[0] as Either<String, UserModel>).fold((l) {
        emit(state.copyWith(status: MenuStatus.failure));
      }, (r) {
        emit(state.copyWith(
          user: r,
        ));
      });
      (result[1] as Either<String, List<RepModel>>).fold((l) {}, (r) {
        emit(state.copyWith(
          reps: r,
        ));
      });
      emit(state.copyWith(
          status: MenuStatus.hadlogin,
          isStateAtCurrentPage: event.isStateAtCurrentPage));
    } else {
      emit(state.copyWith(
          status: MenuStatus.notlogin,
          isStateAtCurrentPage: event.isStateAtCurrentPage));
    }
  }

  void _onMenuSelectMoreEvent(
      MenuSelectMoreEvent event, Emitter<MenuState> emit) {
    emit(state.copyWith(isEnableMore: event.isMoreEnable));
  }

  void _onMenuLogoutSuccessEvent(
      MenuLogoutSuccessEvent event, Emitter<MenuState> emit) {
    emit(state.copyWith(status: MenuStatus.notlogin));
  }
}
