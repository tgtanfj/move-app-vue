import '../widgets/gender_radio_group.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileInitialEvent extends ProfileEvent {}

class ProfileGenderChangedEvent extends ProfileEvent {
  final Gender selectedGender;

  const ProfileGenderChangedEvent({required this.selectedGender});
}
