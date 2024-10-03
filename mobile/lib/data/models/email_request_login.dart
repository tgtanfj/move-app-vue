class EmailRequestLogin {
  final String? idToken;
  final String? email;

  EmailRequestLogin({
    this.idToken,
    this.email,
  });

  factory EmailRequestLogin.fromJson(Map<String, dynamic> json) {
    return EmailRequestLogin(
      idToken: json['tokenId'] is String? ? json['tokenId'] : '',
      email: json['email'] is String? ? json['email'] : '',
    );
  }

  EmailRequestLogin copyWith({
    String? idToken,
    String? email,
  }) {
    return EmailRequestLogin(
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
