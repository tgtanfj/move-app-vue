import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/gifts_repository.dart';
import 'package:move_app/data/repositories/rep_repository.dart';
import 'package:move_app/data/repositories/user_repository.dart';
import 'package:move_app/presentation/screens/gift_reps/bloc/gift_reps_event.dart';
import 'package:move_app/presentation/screens/gift_reps/bloc/gift_reps_state.dart';

class GiftRepsBloc extends Bloc<GiftRepsEvent, GiftRepsState> {
  final GiftsRepository giftsRepository = GiftsRepository();
  final UserRepository userRepository = UserRepository();
  final RepRepository repRepository = RepRepository();

  GiftRepsBloc() : super(GiftRepsState.initial()) {
    on<GiftRepsInitialEvent>(_onGiftRepsInitialEvent);
    on<GiftRepsSelectedGiftEvent>(_onGiftRepsSelectedGiftEvent);
    on<GiftRepsSelectedTitleEvent>(_onGiftRepsSelectedTitleEvent);
    on<GiftRepsSendGiftEvent>(_onGiftRepsSendGiftEvent);
  }

  void _onGiftRepsInitialEvent(
      GiftRepsInitialEvent event, Emitter<GiftRepsState> emit) async {
    emit(state.copyWith(
        status: GiftRepsStatus.loading,
        videoId: event.videoId ?? state.videoId));
    final result = await giftsRepository.getGifts();
    final user = await userRepository.getUserProfile();
    final listRep = await repRepository.getListRep();
    result.fold((l) {
      emit(state.copyWith(
        status: GiftRepsStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(listGifts: r, status: GiftRepsStatus.success));
    });

    user.fold((l) {
      emit(state.copyWith(
        status: GiftRepsStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(user: r, status: GiftRepsStatus.success));
    });

    listRep.fold((l) {
      emit(state.copyWith(status: GiftRepsStatus.failure));
    }, (r) {
      emit(state.copyWith(reps: r, status: GiftRepsStatus.success));
    });
  }

  void _onGiftRepsSelectedGiftEvent(
      GiftRepsSelectedGiftEvent event, Emitter<GiftRepsState> emit) {
    if (state.titleGiftIdSelected! < 0) {
      emit(state.copyWith(titleGiftIdSelected: 0));
    }
    emit(state.copyWith(giftIdSelected: event.giftId));
    final numberOfREPs = state.listGifts?[event.giftId].numberOfREPs ?? 0;
    final repOfUser = state.user?.numberOfREPs ?? 0;

    if (repOfUser >= numberOfREPs) {
      emit(state.copyWith(isSendEnabled: true));
    } else {
      emit(state.copyWith(isSendEnabled: false));
    }
  }

  void _onGiftRepsSelectedTitleEvent(
      GiftRepsSelectedTitleEvent event, Emitter<GiftRepsState> emit) {
    emit(state.copyWith(titleGiftIdSelected: event.titleId));
  }

  void _onGiftRepsSendGiftEvent(
      GiftRepsSendGiftEvent event, Emitter<GiftRepsState> emit) async {
    final result = await giftsRepository.sendGift(
        giftId: state.listGifts?[state.giftIdSelected ?? 0].id ?? 0,
        videoId: state.videoId ?? 0,
        content:
            GiftRepMessageType.values[state.titleGiftIdSelected ?? 0].title);
    result.fold((l) {
      emit(state.copyWith(
        status: GiftRepsStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(status: GiftRepsStatus.giftSuccess));
    });
  }
}
