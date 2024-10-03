class FacebookRequestLogin {
  final String? idToken;
  final String? email;

  FacebookRequestLogin({
    this.idToken,
    this.email,
  });

  factory FacebookRequestLogin.fromJson(Map<String, dynamic> json) {
    return FacebookRequestLogin(
      idToken: json['tokenId'] is String? ? json['tokenId'] : '',
      email: json['email'] is String? ? json['email'] : '',
    );
  }

  FacebookRequestLogin copyWith({
    String? idToken,
    String? email,
  }) {
    return FacebookRequestLogin(
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
