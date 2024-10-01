class UserModel {
  final String? avatar;
  final String? email;
  final String? username;
  final String? password;
  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? city;
  final String? referralCode;

  UserModel({
     this.avatar,
     this.email,
     this.username,
     this.password,
     this.fullName,
     this.gender,
     this.dateOfBirth,
     this.city,
     this.referralCode
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      avatar: json['avatar'] is String? ? json['avatar'] : '',
      email: json['email'] is String? ? json['email'] : '',
      username: json['username'] is String? ? json['username'] : '',
      password: json['password'] is String? ? json['password'] : '',
      fullName: json['fullName'] is String? ? json['fullName'] : '',
      gender: json['gender'] is String? ? json['gender'] : '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
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
    String? city,
    String? referralCode
  }) {
    return UserModel(
        avatar: avatar ?? this.avatar,
        email: email ?? this.email,
        username: username ?? this.username,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        city: city ?? this.city,
        referralCode: referralCode ?? this.referralCode
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
}
