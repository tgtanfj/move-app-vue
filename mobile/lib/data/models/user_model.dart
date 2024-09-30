class UserModel {
  final String? email;
  final String? password;

  UserModel({
    required this.email,
    required this.password,
  });

  UserModel copyWith({
    String? email,
    String? password,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'] is String ? json['email'] : '',
        password: json['password'] is String ? json['password'] : '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
