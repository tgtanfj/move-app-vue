import 'package:equatable/equatable.dart';

import '../widgets/gender_radio_group.dart';

enum ProfileStatus {
  initial,
  processing,
  success,
  failure,
}

final class ProfileState extends Equatable {
  final ProfileStatus? status;
  final Gender? selectedGender;

  const ProfileState({
    this.selectedGender,
    this.status,
  });

  static ProfileState initial() => const ProfileState(
        status: ProfileStatus.initial,
        selectedGender: Gender.male,
      );

  ProfileState copyWith({
    ProfileStatus? status,
    Gender? selectedGender,
  }) {
    return ProfileState(
      status: status ?? this.status,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedGender,
      ];
}
