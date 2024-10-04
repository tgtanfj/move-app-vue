class LoginRequestSocial {
  final String? idToken;
  final String? email;

  LoginRequestSocial({
    this.idToken,
    this.email,
  });

  factory LoginRequestSocial.fromJson(Map<String, dynamic> json) {
    return LoginRequestSocial(
      idToken: json['tokenId'] is String? ? json['tokenId'] : '',
      email: json['email'] is String? ? json['email'] : '',
    );
  }

  LoginRequestSocial copyWith({
    String? idToken,
    String? email,
  }) {
    return LoginRequestSocial(
      idToken: idToken ?? this.idToken,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'email': email,
    };
  }
}
