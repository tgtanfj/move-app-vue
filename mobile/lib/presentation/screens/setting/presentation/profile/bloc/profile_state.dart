import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/state_model.dart';
import 'package:move_app/data/models/user_model.dart';

enum ProfileStatus {
  initial,
  processing,
  success,
  failure,
}

final class ProfileState extends Equatable {
  final ProfileStatus? status;
  final String? errorMessage;
  final UserModel? user;
  final List<CountryModel> countryList;
  final List<StateModel> stateList;
  final bool isEnableSaveSettings;
  final String messageInputUsername;
  final String messageInputFullName;
  final String messageInputCity;
  final bool isShowUsernameMessage;
  final bool isShowFullNameMessage;
  final bool isShowCityMessage;
  final File? imageLocal;
  final String messageSelectDateOfBirth;
  final String messageSelectCountry;
  final String messageSelectState;
  final String messageUpdateAvatar;
  final bool isShowDateOfBirthMessage;
  final bool isShowCountryMessage;
  final bool isShowStateMessage;
  final bool isShowAvatarMessage;

  const ProfileState({
    this.status,
    this.errorMessage,
    this.user,
    required this.countryList,
    required this.stateList,
    this.isEnableSaveSettings = false,
    this.messageInputUsername = '',
    this.messageInputFullName = '',
    this.messageInputCity = '',
    this.isShowUsernameMessage = false,
    this.isShowFullNameMessage = false,
    this.isShowCityMessage = false,
    this.imageLocal,
    this.messageSelectDateOfBirth = '',
    this.messageSelectCountry = '',
    this.messageSelectState = '',
    this.messageUpdateAvatar = '',
    this.isShowDateOfBirthMessage = false,
    this.isShowCountryMessage = false,
    this.isShowStateMessage = false,
    this.isShowAvatarMessage = false,
  });

  static ProfileState initial() => const ProfileState(
        status: ProfileStatus.initial,
        user: null,
        countryList: [],
        stateList: [],
        isEnableSaveSettings: false,
        messageInputUsername: '',
        messageInputFullName: '',
        messageInputCity: '',
        isShowUsernameMessage: false,
        isShowFullNameMessage: false,
        isShowCityMessage: false,
        messageSelectDateOfBirth: '',
        messageSelectCountry: '',
        messageSelectState: '',
        messageUpdateAvatar: '',
        isShowDateOfBirthMessage: false,
        isShowCountryMessage: false,
        isShowStateMessage: false,
        isShowAvatarMessage: false,
      );

  ProfileState copyWith({
    ProfileStatus? status,
    String? errorMessage,
    UserModel? user,
    List<CountryModel>? countryList,
    List<StateModel>? stateList,
    bool? isEnableSaveSettings,
    String? messageInputUsername,
    String? messageInputFullName,
    String? messageInputCity,
    bool? isShowUsernameMessage,
    bool? isShowFullNameMessage,
    bool? isShowCityMessage,
    File? imageLocal,
    String? messageSelectDateOfBirth,
    String? messageSelectCountry,
    String? messageSelectState,
    String? messageUpdateAvatar,
    bool? isShowDateOfBirthMessage,
    bool? isShowCountryMessage,
    bool? isShowStateMessage,
    bool? isShowUpdateMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      countryList: countryList ?? this.countryList,
      stateList: stateList ?? this.stateList,
      isEnableSaveSettings: isEnableSaveSettings ?? this.isEnableSaveSettings,
      messageInputUsername: messageInputUsername ?? this.messageInputUsername,
      messageInputFullName: messageInputFullName ?? this.messageInputFullName,
      messageInputCity: messageInputCity ?? this.messageInputCity,
      isShowUsernameMessage:
          isShowUsernameMessage ?? this.isShowUsernameMessage,
      isShowFullNameMessage:
          isShowFullNameMessage ?? this.isShowFullNameMessage,
      isShowCityMessage: isShowCityMessage ?? this.isShowCityMessage,
      imageLocal: imageLocal ?? this.imageLocal,
      messageSelectDateOfBirth:
          messageSelectDateOfBirth ?? this.messageSelectDateOfBirth,
      messageSelectCountry: messageSelectCountry ?? this.messageSelectCountry,
      messageSelectState: messageSelectState ?? this.messageSelectState,
      messageUpdateAvatar: messageUpdateAvatar ?? this.messageUpdateAvatar,
      isShowDateOfBirthMessage:
          isShowDateOfBirthMessage ?? this.isShowDateOfBirthMessage,
      isShowCountryMessage: isShowCountryMessage ?? this.isShowCountryMessage,
      isShowStateMessage: isShowStateMessage ?? this.isShowStateMessage,
      isShowAvatarMessage: isShowUpdateMessage ?? this.isShowAvatarMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        user,
        countryList,
        stateList,
        isEnableSaveSettings,
        messageInputUsername,
        messageInputFullName,
        messageInputCity,
        isShowUsernameMessage,
        isShowFullNameMessage,
        isShowCityMessage,
        imageLocal,
        messageSelectDateOfBirth,
        messageSelectCountry,
        messageSelectState,
        messageUpdateAvatar,
        isShowDateOfBirthMessage,
        isShowCountryMessage,
        isShowStateMessage,
        isShowAvatarMessage,
      ];
}
