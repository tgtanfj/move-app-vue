import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/state_model.dart';
import 'package:move_app/data/models/user_model.dart';

import '../widgets/gender_radio_group.dart';

enum ProfileStatus {
  initial,
  processing,
  success,
  failure,
}

final class ProfileState extends Equatable {
  final ProfileStatus? status;
  final Gender selectedGender;
  final String? errorMessage;
  final UserModel? user;
  final List<CountryModel> countryList;
  final List<StateModel> stateList;
  final bool isEnableSaveSettings;
  final String inputUsername;
  final String inputFullName;
  final String inputCity;
  final String messageInputUsername;
  final String messageInputFullName;
  final String messageInputCity;
  final bool isShowUsernameMessage;
  final bool isShowFullNameMessage;
  final bool isShowCityMessage;

  const ProfileState({
    required this.selectedGender,
    this.status,
    this.errorMessage,
    this.user,
    required this.countryList,
    required this.stateList,
    this.isEnableSaveSettings = false,
    this.inputUsername = '',
    this.inputFullName = '',
    this.inputCity = '',
    this.messageInputUsername = '',
    this.messageInputFullName = '',
    this.messageInputCity = '',
    this.isShowUsernameMessage = false,
    this.isShowFullNameMessage = false,
    this.isShowCityMessage = false,
  });

  static ProfileState initial() => const ProfileState(
        status: ProfileStatus.initial,
        selectedGender: Gender.male,
        user: null,
        countryList: [],
        stateList: [],
        isEnableSaveSettings: false,
        inputUsername: '',
        inputFullName: '',
        inputCity: '',
        messageInputUsername: '',
        messageInputFullName: '',
        messageInputCity: '',
        isShowUsernameMessage: false,
        isShowFullNameMessage: false,
        isShowCityMessage: false,
      );

  ProfileState copyWith({
    ProfileStatus? status,
    Gender? selectedGender,
    String? errorMessage,
    UserModel? user,
    List<CountryModel>? countryList,
    List<StateModel>? stateList,
    bool? isEnableSaveSettings,
    String? inputUsername,
    String? inputFullName,
    String? inputCity,
    String? messageInputUsername,
    String? messageInputFullName,
    String? messageInputCity,
    bool? isShowUsernameMessage,
    bool? isShowFullNameMessage,
    bool? isShowCityMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      selectedGender: selectedGender ?? this.selectedGender,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      countryList: countryList ?? this.countryList,
      stateList: stateList ?? this.stateList,
      isEnableSaveSettings: isEnableSaveSettings ?? this.isEnableSaveSettings,
      inputUsername: inputUsername ?? this.inputUsername,
      inputFullName: inputFullName ?? this.inputFullName,
      inputCity: inputCity ?? this.inputCity,
      messageInputUsername: messageInputUsername ?? this.messageInputUsername,
      messageInputFullName: messageInputFullName ?? this.messageInputFullName,
      messageInputCity: messageInputCity ?? this.messageInputCity,
      isShowUsernameMessage:
          isShowUsernameMessage ?? this.isShowUsernameMessage,
      isShowFullNameMessage:
          isShowFullNameMessage ?? this.isShowFullNameMessage,
      isShowCityMessage: isShowCityMessage ?? this.isShowCityMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedGender,
        errorMessage,
        user,
        countryList,
        stateList,
        isEnableSaveSettings,
        inputUsername,
        inputFullName,
        inputCity,
        messageInputUsername,
        messageInputFullName,
        messageInputCity,
        isShowUsernameMessage,
        isShowFullNameMessage,
        isShowCityMessage,
      ];
}
