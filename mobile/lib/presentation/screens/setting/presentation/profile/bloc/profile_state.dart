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
  final List<Country> countryList;
  final List<State> stateList;
  final int? selectedCountry;
  final int? selectedState;
  final DateTime? dateOfBirth;

  const ProfileState({
    required this.selectedGender,
    this.status,
    this.errorMessage,
    this.user,
    required this.countryList,
    required this.stateList,
    this.selectedCountry,
    this.selectedState,
    this.dateOfBirth,
  });

  static ProfileState initial() => const ProfileState(
        status: ProfileStatus.initial,
        selectedGender: Gender.male,
        user: null,
        countryList: [],
        stateList: [],
      );

  ProfileState copyWith({
    ProfileStatus? status,
    Gender? selectedGender,
    String? errorMessage,
    UserModel? user,
    List<Country>? countryList,
    List<State>? stateList,
    int? selectedCountry,
    int? selectedState,
    DateTime? dateOfBirth,
  }) {
    return ProfileState(
      status: status ?? this.status,
      selectedGender: selectedGender ?? this.selectedGender,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      countryList: countryList ?? this.countryList,
      stateList: stateList ?? this.stateList,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedState: selectedState ?? this.selectedState,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
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
        selectedCountry,
        selectedState,
        dateOfBirth,
      ];
}
