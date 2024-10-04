class ObjectLoginSocial {
  final String? idToken;
  final String? email;

  ObjectLoginSocial({
    this.idToken,
    this.email,
  });

  factory ObjectLoginSocial.fromJson(Map<String, dynamic> json) {
    return ObjectLoginSocial(
      idToken: json['tokenId'] is String? ? json['tokenId'] : '',
      email: json['email'] is String? ? json['email'] : '',
    );
  }

  ObjectLoginSocial copyWith({
    String? idToken,
    String? email,
  }) {
    return ObjectLoginSocial(
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
