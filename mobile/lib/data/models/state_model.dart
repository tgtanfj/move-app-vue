class StateModel {
  final int? id;
  final String? name;

  StateModel({
    required this.id,
    required this.name,
  });

  StateModel copyWith({
    int? id,
    String? name,
  }) {
    return StateModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'] is int? ? json['id'] : 0,
      name: json['name'] is String? ? json['name'] : '',
    );
  }
}
