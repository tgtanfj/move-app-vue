import '../widgets/gender_radio_group.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileInitialEvent extends ProfileEvent {}

class ProfileGenderChangedEvent extends ProfileEvent {
  final Gender selectedGender;

  const ProfileGenderChangedEvent({required this.selectedGender});
}

class ProfileCountrySelectEvent extends ProfileEvent {
  final int countryId;

  const ProfileCountrySelectEvent({required this.countryId});
}

class ProfileStateSelectEvent extends ProfileEvent {
  final int stateId;

  const ProfileStateSelectEvent({required this.stateId});
}

class ProfileUpdateDateOfBirthEvent extends ProfileEvent {
  final DateTime dateOfBirth;

  const ProfileUpdateDateOfBirthEvent(this.dateOfBirth);
}

class ProfileUsernameChangeEvent extends ProfileEvent {
  final String? username;

  const ProfileUsernameChangeEvent({this.username});
}

class ProfileFullNameChangeEvent extends ProfileEvent {
  final String? fullName;

  const ProfileFullNameChangeEvent({this.fullName});
}

class ProfileCityChangeEvent extends ProfileEvent {
  final String? city;

  const ProfileCityChangeEvent({this.city});
}

class ProfileSaveSettingsEvent extends ProfileEvent {}

class ProfileUpdateAvatarEvent extends ProfileEvent {}
