import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/data/repositories/country_repository.dart';
import 'package:move_app/data/repositories/state_repository.dart';
import 'package:move_app/data/repositories/user_repository.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/bloc/profile_event.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/bloc/profile_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

import '../../../../../../data/models/state_model.dart';

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
    on<ProfileSaveSettingsEvent>(_onProfileSaveSettingsEvent);
    on<ProfileUpdateAvatarEvent>(_onProfileUpdateAvatarEvent);
    on<ProfileUsernameChangeEvent>(_onProfileUsernameChangEvent);
    on<ProfileFullNameChangeEvent>(_onProfileFullNameChangEvent);
    on<ProfileCityChangeEvent>(_onProfileCityChangEvent);
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
        user: r,
      ));
    });
    (result[1] as Either<String, List<CountryModel>>).fold((l) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        countryList: r,
      ));
    });
    if (state.user?.country?.id != null) {
      final states =
          await stateRepository.getStateList(state.user!.country!.id!);
      states.fold((l) {}, (r) {
        emit(state.copyWith(stateList: r));
      });
    }
    final isEnableSaveSettings = (state.user?.username?.isNotEmpty ?? false) &&
        (state.user?.fullName?.isNotEmpty ?? false);
    emit(state.copyWith(isEnableSaveSettings: isEnableSaveSettings));
  }

  void _onProfileGenderChangedEvent(
      ProfileGenderChangedEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(status: ProfileStatus.processing));
    emit(state.copyWith(
        user: state.user?.copyWith(gender: event.selectedGender.value)));
  }

  void _onProfileCountrySelectEvent(
    ProfileCountrySelectEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.processing));
    final result = await stateRepository.getStateList(event.countryId);
    result.fold((l) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }, (r) {
      emit(state.copyWith(
        user: state.user?.copyWith(
          country: state.countryList.firstWhere(
            (e) => e.id == event.countryId,
          ),
          state: StateModel(id: 0, name: ''),
        ),
        stateList: r,
        isShowCountryMessage: false,
        isShowStateMessage: false,
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
    emit(state.copyWith(user: updateUser, isShowStateMessage: false));
  }

  void _onProfileUpdateDateOfBirthEvent(
    ProfileUpdateDateOfBirthEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.processing));
    final updateUser = state.user?.copyWith(dateOfBirth: event.dateOfBirth);
    final isShowDateOfBirthMessage =
        state.user?.dateOfBirth != event.dateOfBirth
            ? false
            : state.isShowDateOfBirthMessage;
    if (updateUser != null) {
      emit(state.copyWith(
        user: updateUser,
        isShowDateOfBirthMessage: isShowDateOfBirthMessage,
      ));
    }
  }

  void _onProfileUsernameChangEvent(
    ProfileUsernameChangeEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.processing));
    final updateUser = state.user?.copyWith(username: event.username);
    final isEnableSaveSettings = (updateUser?.username?.isNotEmpty ?? false) &&
        (state.user?.fullName?.isNotEmpty ?? false);
    final isShowUsernameMessage = state.user?.username != event.username
        ? false
        : state.isShowUsernameMessage;
    emit(state.copyWith(
      user: updateUser,
      isEnableSaveSettings: isEnableSaveSettings,
      isShowUsernameMessage: isShowUsernameMessage,
    ));
  }

  void _onProfileFullNameChangEvent(
    ProfileFullNameChangeEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.processing));
    final updateUser = state.user?.copyWith(fullName: event.fullName);
    final isEnableSaveSettings = (state.user?.username?.isNotEmpty ?? false) &&
        (updateUser?.fullName?.isNotEmpty ?? false);
    final isShowFullNameMessage = state.user?.username != event.fullName
        ? false
        : state.isShowFullNameMessage;
    emit(state.copyWith(
        user: updateUser,
        isEnableSaveSettings: isEnableSaveSettings,
        isShowFullNameMessage: isShowFullNameMessage));
  }

  void _onProfileCityChangEvent(
    ProfileCityChangeEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.processing));
    final updateUser = state.user?.copyWith(city: event.city);
    emit(state.copyWith(
      user: updateUser,
    ));
  }

  void _onProfileSaveSettingsEvent(
    ProfileSaveSettingsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final validUsername =
        InputValidationHelper.validateUsername(state.user?.username ?? '');
    final validFullName =
        InputValidationHelper.validateFullName(state.user?.fullName ?? '');
    final validDateOfBirth =
        InputValidationHelper.validateDateOfBirth(state.user?.dateOfBirth);
    final validCountry = InputValidationHelper.validateStringValue(
        state.user?.country?.name ?? '');
    final validState = InputValidationHelper.validateStringValue(
        state.user?.state?.name ?? '');
    final validAvatar =
        await InputValidationHelper.validateImage(state.imageLocal);
    emit(state.copyWith(
      isShowUsernameMessage: validUsername != null,
      isShowFullNameMessage: validFullName != null,
      messageInputUsername: validUsername,
      messageInputFullName: validFullName,
      isShowDateOfBirthMessage: validDateOfBirth != null,
      isShowCountryMessage: validCountry != null,
      isShowStateMessage: validState != null,
      isShowUpdateMessage: validAvatar != null,
      messageSelectDateOfBirth: validDateOfBirth,
      messageSelectCountry: validCountry,
      messageSelectState: validState,
      messageUpdateAvatar: validAvatar,
    ));
    if (validUsername == null &&
        validFullName == null &&
        validDateOfBirth == null &&
        validCountry == null &&
        validState == null) {
      emit(state.copyWith(
          user: state.user?.copyWith(
              username: state.user?.username,
              fullName: state.user?.fullName,
              city: state.user?.city,
              dateOfBirth: state.user?.dateOfBirth,
              country: state.user?.country,
              state: state.user?.state)));
      final result =
          await userRepository.editUserProfile(state.user, state.imageLocal);
      result.fold((l) {
        if (l.contains('username')) {
          emit(state.copyWith(
            status: ProfileStatus.failure,
            isShowUsernameMessage: true,
            messageInputUsername: l,
          ));
        }
        emit(state.copyWith(status: ProfileStatus.failure));
      }, (r) {
        emit(state.copyWith(
          status: ProfileStatus.success,
        ));
      });
      if (state.status == ProfileStatus.success) {
        final editedUser = await userRepository.getUserProfile();
        editedUser.fold((l) {
          emit(state.copyWith(status: ProfileStatus.failure));
        }, (r) {
          emit(state.copyWith(
            user: r,
          ));
        });
      }
    }
  }

  void _onProfileUpdateAvatarEvent(
    ProfileUpdateAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.processing));
    final result = await userRepository.pickImageFromGallery();
    result.fold((l) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }, (r) {
      if (r != null) {
        final avatarPath = r.path;
        emit(state.copyWith(
          imageLocal: r,
          user: state.user?.copyWith(avatar: avatarPath),
        ));
      } else {
        emit(state.copyWith(status: ProfileStatus.failure));
      }
    });
  }
}
