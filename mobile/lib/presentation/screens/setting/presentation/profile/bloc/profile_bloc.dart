import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/data/repositories/country_repository.dart';
import 'package:move_app/data/repositories/state_repository.dart';
import 'package:move_app/data/repositories/user_repository.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/bloc/profile_event.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final userRepository = UserRepository();
  final countryRepository = CountryRepository();
  final stateRepository = StateRepository();

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileInitialEvent>(_onProfileInitialEvent);
    on<ProfileGenderChangedEvent>(_onProfileGenderChangedEvent);
    on<ProfileCountrySelectEvent>(_onProfileCountrySelectEvent);
    on<ProfileStateSelectEvent>(_onProfileStateSelectEvent);
    on<ProfileUpdateDateOfBirthEvent>(_onProfileUpdateDateOfBirthEvent);
  }

  void _onProfileInitialEvent(
      ProfileInitialEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.processing));
    final result = await Future.wait([
      userRepository.getUserProfile(),
      countryRepository.getCountryList(),
    ]);
    (result[0] as Either<String, UserModel>).fold((l) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }, (r) {
      emit(state.copyWith(
        status: ProfileStatus.success,
        user: r,
        selectedCountry: r.country?.id,
        dateOfBirth: r.dateOfBirth,
      ));
    });
    (result[1] as Either<String, List<Country>>).fold((l) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        status: ProfileStatus.success,
        countryList: r,
      ));
    });
  }

  void _onProfileGenderChangedEvent(
      ProfileGenderChangedEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(status: ProfileStatus.processing));
    emit(state.copyWith(
      selectedGender: event.selectedGender,
    ));
  }

  void _onProfileCountrySelectEvent(
    ProfileCountrySelectEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.processing));
    emit(state.copyWith(selectedCountry: event.countryId));
    final result = await stateRepository.getStateList(event.countryId);
    result.fold((l) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }, (r) {
      emit(state.copyWith(
        status: ProfileStatus.success,
        selectedCountry: event.countryId,
        stateList: r,
        selectedState: null,
      ));
    });
  }

  void _onProfileStateSelectEvent(
    ProfileStateSelectEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.processing));
    emit(state.copyWith(
      status: ProfileStatus.success,
      selectedState: event.stateId,
    ));
  }

  void _onProfileUpdateDateOfBirthEvent(
    ProfileUpdateDateOfBirthEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      status: ProfileStatus.processing,
      dateOfBirth: event.dateOfBirth,
    ));
  }
}
