import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/data/repositories/country_repository.dart';
import 'package:move_app/data/repositories/state_repository.dart';
import 'package:move_app/data/repositories/user_repository.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/bloc/profile_event.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/bloc/profile_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

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
    on<ProfileValueChangeEvent>(_onProfileValueChangeEvent);
    on<ProfileSaveSettingsEvent>(_onProfileSaveSettingsEvent);
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
      ));
    });
    (result[1] as Either<String, List<CountryModel>>).fold((l) {
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
    final updateUser = state.user?.copyWith(
        country: state.countryList.firstWhere(
      (e) => e.id == event.countryId,
    ));
    final result = await stateRepository.getStateList(event.countryId);
    result.fold((l) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }, (r) {
      emit(state.copyWith(
        status: ProfileStatus.success,
        user: updateUser,
        stateList: r,
      ));
    });
  }

  void _onProfileStateSelectEvent(
    ProfileStateSelectEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.processing));
    final updateUser = state.user?.copyWith(
        state: state.stateList.firstWhere(
      (e) => e.id == event.stateId,
    ));
    emit(state.copyWith(status: ProfileStatus.success, user: updateUser));
  }

  void _onProfileUpdateDateOfBirthEvent(
    ProfileUpdateDateOfBirthEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.processing));
    final updateUser = state.user?.copyWith(dateOfBirth: event.dateOfBirth);
    emit(state.copyWith(
      status: ProfileStatus.success,
      user: updateUser,
    ));
  }

  void _onProfileValueChangeEvent(
    ProfileValueChangeEvent event,
    Emitter<ProfileState> emit,
  ) {
    final settingValues = state.copyWith(
      inputUsername: event.username,
      inputFullName: event.fullName,
      inputCity: event.city,
    );
    final isShowUsernameMessage =
        state.inputUsername != settingValues.inputUsername
            ? false
            : state.isShowUsernameMessage;
    final isShowFullNameMessage =
        state.inputFullName != settingValues.inputFullName
            ? false
            : state.isShowFullNameMessage;
    final isShowCityMessage = state.inputCity != settingValues.inputCity
        ? false
        : state.isShowCityMessage;
    final isEnableSaveSettings = settingValues.inputUsername.isNotEmpty &&
        settingValues.inputFullName.isNotEmpty;
    emit(settingValues.copyWith(
      isEnableSaveSettings: isEnableSaveSettings,
      isShowUsernameMessage: isShowUsernameMessage,
      isShowFullNameMessage: isShowFullNameMessage,
      isShowCityMessage: isShowCityMessage,
    ));
  }

  void _onProfileSaveSettingsEvent(
    ProfileSaveSettingsEvent event,
    Emitter<ProfileState> emit,
  ) {
    final validUsername =
        InputValidationHelper.validateUsername(state.inputUsername);
    final validFullName =
        InputValidationHelper.validateFullName(state.inputFullName);
    final validCity = InputValidationHelper.validateCity(state.inputCity);
    emit(state.copyWith(
      isShowUsernameMessage: validUsername != null,
      isShowFullNameMessage: validFullName != null,
      isShowCityMessage: validCity != null,
      messageInputUsername: validUsername,
      messageInputFullName: validFullName,
      messageInputCity: validCity,
    ));
    if (validUsername == null && validFullName == null && validCity == null) {}
  }
}
