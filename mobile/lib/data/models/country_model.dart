class Country {
  final int? id;
  final String? name;

  Country({
    required this.id,
    required this.name,
  });

  Country copyWith({
    int? id,
    String? name,
  }) {
    return Country(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] is int? ? json['id'] : 0,
      name: json['name'] is String? ? json['name'] : '',
    );
  }
}
