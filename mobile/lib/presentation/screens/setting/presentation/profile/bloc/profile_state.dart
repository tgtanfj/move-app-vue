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
  editUserSuccess,
}

final class ProfileState extends Equatable {
  final ProfileStatus? status;
  final String? errorMessage;
  final UserModel? user;
  final List<CountryModel> countryList;
  final List<StateModel> stateList;
  final String messageInputUsername;
  final String messageInputFullName;
  final bool isShowUsernameMessage;
  final bool isShowFullNameMessage;
  final File? imageLocal;
  final String messageSelectDateOfBirth;
  final String messageSelectCountry;
  final String messageSelectState;
  final String messageUpdateAvatar;
  final bool isShowDateOfBirthMessage;
  final bool isShowCountryMessage;
  final bool isShowStateMessage;
  final bool isShowAvatarMessage;

  const ProfileState(
      {this.status,
      this.errorMessage,
      this.user,
      required this.countryList,
      required this.stateList,
      this.messageInputUsername = '',
      this.messageInputFullName = '',
      this.isShowUsernameMessage = false,
      this.isShowFullNameMessage = false,
      this.imageLocal,
      this.messageSelectDateOfBirth = '',
      this.messageSelectCountry = '',
      this.messageSelectState = '',
      this.messageUpdateAvatar = '',
      this.isShowDateOfBirthMessage = false,
      this.isShowCountryMessage = false,
      this.isShowStateMessage = false,
      this.isShowAvatarMessage = false});

  static ProfileState initial() => const ProfileState(
        status: ProfileStatus.initial,
        user: null,
        countryList: [],
        stateList: [],
        messageInputUsername: '',
        messageInputFullName: '',
        isShowUsernameMessage: false,
        isShowFullNameMessage: false,
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
    String? messageInputUsername,
    String? messageInputFullName,
    bool? isShowUsernameMessage,
    bool? isShowFullNameMessage,
    File? imageLocal,
    String? messageSelectDateOfBirth,
    String? messageSelectCountry,
    String? messageSelectState,
    String? messageUpdateAvatar,
    bool? isShowDateOfBirthMessage,
    bool? isShowCountryMessage,
    bool? isShowStateMessage,
    bool? isShowUpdateMessage,
    bool? isShowAvatarMessage,
  }) {
    return ProfileState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        user: user ?? this.user,
        countryList: countryList ?? this.countryList,
        stateList: stateList ?? this.stateList,
        messageInputUsername: messageInputUsername ?? this.messageInputUsername,
        messageInputFullName: messageInputFullName ?? this.messageInputFullName,
        isShowUsernameMessage:
            isShowUsernameMessage ?? this.isShowUsernameMessage,
        isShowFullNameMessage:
            isShowFullNameMessage ?? this.isShowFullNameMessage,
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
        isShowAvatarMessage: isShowAvatarMessage ?? this.isShowAvatarMessage);
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        user,
        countryList,
        stateList,
        messageInputUsername,
        messageInputFullName,
        isShowUsernameMessage,
        isShowFullNameMessage,
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

  bool get isEnableSaveSettings =>
      (user?.username?.isNotEmpty ?? false) &&
      (user?.fullName?.isNotEmpty ?? false) &&
      (user?.country?.name?.isNotEmpty ?? false) &&
      (user?.state?.name?.isNotEmpty ?? false) &&
      (user?.dateOfBirth?.toString().isNotEmpty ?? false);
}
