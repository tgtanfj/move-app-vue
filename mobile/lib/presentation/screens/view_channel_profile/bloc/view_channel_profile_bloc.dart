import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/view_channel_profile_repository.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_state.dart';

class ViewChannelProfileBloc
    extends Bloc<ViewChannelProfileEvent, ViewChannelProfileState> {
  final channelRepository = ViewChannelProfileRepository();

  ViewChannelProfileBloc() : super(ViewChannelProfileState.initial()) {
    on<ViewChannelProfileEvent>(_onChannelInitialEvent);
    on<ViewChannelProfileFollowingItemSelectEvent>(
        _onViewChannelProfileFollowingItemSelectEvent);
  }

  void _onChannelInitialEvent(ViewChannelProfileEvent event,
      Emitter<ViewChannelProfileState> emit) async {
    emit(state.copyWith(status: ViewChannelProfileStatus.processing));
    final result = await channelRepository.getViewChannelProfileAbout(2);
    result.fold((l) {
      emit(state.copyWith(status: ViewChannelProfileStatus.failure));
    }, (r) {
      emit(state.copyWith(
        status: ViewChannelProfileStatus.success,
        channel: r,
      ));
    });
  }

  void _onViewChannelProfileFollowingItemSelectEvent(
      ViewChannelProfileFollowingItemSelectEvent event,
      Emitter<ViewChannelProfileState> emit) async {
    emit(state.copyWith(status: ViewChannelProfileStatus.processing));
    final result = await channelRepository
        .getViewChannelProfileAbout(event.followingItemId);
    result.fold((l) {
      emit(state.copyWith(status: ViewChannelProfileStatus.failure));
    }, (r) {
      emit(state.copyWith(
        channel: r,
      ));
    });
  }
}
