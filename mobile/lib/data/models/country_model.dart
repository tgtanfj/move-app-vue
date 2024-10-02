class CountryModel {
  final int? id;
  final String? name;

  CountryModel({
    required this.id,
    required this.name,
  });

  CountryModel copyWith({
    int? id,
    String? name,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] is int? ? json['id'] : 0,
      name: json['name'] is String? ? json['name'] : '',
    );
  }
}
