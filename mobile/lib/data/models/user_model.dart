import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/state_model.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/widgets/gender_radio_group.dart';

class UserModel {
  final bool isBlueBadge;
  final bool isPinkBadge;
  final String? avatar;
  final String? email;
  final String? username;
  final String? password;
  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final CountryModel? country;
  final StateModel? state;
  final String? city;
  final String? referralCode;

  UserModel({
    this.isBlueBadge = false,
    this.isPinkBadge = false,
    this.avatar,
    this.email,
    this.username,
    this.password,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.country,
    this.state,
    this.city,
    this.referralCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isBlueBadge: json['isBlueBadge'] is bool? ? json['isBlueBadge'] : false,
      isPinkBadge: json['isPinkBadge'] is bool? ? json['isPinkBadge'] : false,
      avatar: json['avatar'] is String? ? json['avatar'] : '',
      email: json['email'] is String? ? json['email'] : '',
      username: json['username'] is String? ? json['username'] : '',
      password: json['password'] is String? ? json['password'] : '',
      fullName: json['fullName'] is String? ? json['fullName'] : '',
      gender: json['gender'] is String? ? json['gender'] : Gender.male,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      country: json['country'] != null
          ? CountryModel.fromJson(json['country'])
          : CountryModel(id: 0, name: ''),
      state: json['state'] != null
          ? StateModel.fromJson(json['state'])
          : StateModel(id: 0, name: ''),
      city: json['city'] is String? ? json['city'] : '',
      referralCode: json['referralCode'] is String? ? json['referralCode'] : '',
    );
  }

  UserModel copyWith({
    String? avatar,
    String? email,
    String? username,
    String? password,
    String? fullName,
    String? gender,
    DateTime? dateOfBirth,
    CountryModel? country,
    StateModel? state,
    String? city,
    String? referralCode,
    bool? isBlueBadge,
    bool? isPinkBadge,
  }) {
    return UserModel(
      isBlueBadge: isBlueBadge ?? this.isBlueBadge,
      isPinkBadge: isPinkBadge ?? this.isPinkBadge,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  Map<String, dynamic> editUserToJson() {
    return {
      'avatar': avatar,
      'username': username,
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toString(),
      'countryId': country?.id,
      'stateId': state?.id,
      'city': city,
    };
  }
}
