class CountryModel {
  final int? id;
  final String? name;
  final String? countryCode;

  CountryModel({
    required this.id,
    required this.name,
    required this.countryCode,
  });

  CountryModel copyWith({
    int? id,
    String? name,
    String? countryCode,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] is int? ? json['id'] : 0,
      name: json['name'] is String? ? json['name'] : '',
      countryCode: json['countryCode'] is String? ? json['countryCode'] : '',
    );
  }
}
