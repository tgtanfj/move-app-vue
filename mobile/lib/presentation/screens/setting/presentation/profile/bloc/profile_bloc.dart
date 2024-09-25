import 'package:bloc/bloc.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/bloc/profile_event.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileInitialEvent>(_onProfileInitialEvent);
    on<ProfileGenderChangedEvent>(_onProfileGenderChangedEvent);
  }

  void _onProfileInitialEvent(
      ProfileInitialEvent event, Emitter<ProfileState> emit) {}

  void _onProfileGenderChangedEvent(
      ProfileGenderChangedEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(selectedGender: event.selectedGender));
  }
}
