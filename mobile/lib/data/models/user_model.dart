import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/data/models/state_model.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/widgets/gender_radio_group.dart';

class UserModel {
  final int? id;
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
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? deletedAt;
  final String? role;
  final bool? isActive;
  final String? stripeId;
  UserModel({
    this.id,
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
    this.updatedAt,
    this.createdAt,
    this.deletedAt,
    this.role,
    this.isActive,
    this.stripeId,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isBlueBadge: json['isBlueBadge'] is bool? ? json['isBlueBadge'] : false,
      isPinkBadge: json['isPinkBadge'] is bool? ? json['isPinkBadge'] : false,
      id: json['id'] as int?,
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
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      role: json['role'] is String ? json['role'] : '',
      isActive: json['isActive'] as bool?,
      stripeId: json['stripeId'] is String ? json['stripeId'] : '',

    );
  }

  UserModel copyWith({
    int? id,
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
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deletedAt,
    String? role,
    bool? isActive,
    String? stripeId,
  }) {
    return UserModel(
      isBlueBadge: isBlueBadge ?? this.isBlueBadge,
      isPinkBadge: isPinkBadge ?? this.isPinkBadge,
      id: id ?? this.id,
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
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      stripeId: stripeId ?? this.stripeId,
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
