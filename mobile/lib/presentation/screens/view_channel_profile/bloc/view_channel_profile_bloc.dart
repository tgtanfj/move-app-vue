import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/view_channel_profile_repository.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_state.dart';

class ViewChannelProfileBloc
    extends Bloc<ViewChannelProfileEvent, ViewChannelProfileState> {
  final channelRepository = ViewChannelProfileRepository();

  ViewChannelProfileBloc() : super(ViewChannelProfileState.initial()) {
    on<ViewChannelProfileInitialEvent>(_onChannelInitialEvent);
    on<ViewChannelProfileFollowingItemSelectEvent>(
        _onViewChannelProfileFollowingItemSelectEvent);
    on<ViewChannelProfileFollowChannelEvent>(
        _onViewChannelProfileFollowChannelEvent);
  }

  void _onChannelInitialEvent(ViewChannelProfileInitialEvent event,
      Emitter<ViewChannelProfileState> emit) async {
    emit(state.copyWith(
      status: ViewChannelProfileStatus.processing,
      channelId: event.idChannel,
    ));
    
    final channelResult =
        await channelRepository.getViewChannelProfileAbout(event.idChannel);

    channelResult.fold((failure) {
      emit(state.copyWith(status: ViewChannelProfileStatus.failure));
    }, (r) async {
      emit(state.copyWith(
        status: ViewChannelProfileStatus.success,
        channel: r.copyWith(id: event.idChannel),
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
        status: ViewChannelProfileStatus.success,
        channel: r,
      ));
    });
  }

  void _onViewChannelProfileFollowChannelEvent(
      ViewChannelProfileFollowChannelEvent event,
      Emitter<ViewChannelProfileState> emit) async {
    emit(state.copyWith(status: ViewChannelProfileStatus.processing));
    if (state.channel?.isFollowed == true) {
      final result =
          await channelRepository.unFollowChannel(state.channel?.id ?? 0);
      result.fold((l) {
        emit(state.copyWith(
          status: ViewChannelProfileStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(
          status: ViewChannelProfileStatus.success,
          channel: state.channel?.copyWith(isFollowed: false),
        ));
      });
    } else {
      final result =
          await channelRepository.followChannel(state.channel?.id ?? 0);
      result.fold((l) {
        emit(state.copyWith(
          status: ViewChannelProfileStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(
          status: ViewChannelProfileStatus.success,
          channel: state.channel?.copyWith(isFollowed: true),
        ));
      });
    }
  }
}
