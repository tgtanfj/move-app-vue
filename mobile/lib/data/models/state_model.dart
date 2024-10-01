class State {
  final int? id;
  final String? name;

  State({
    required this.id,
    required this.name,
  });

  State copyWith({
    int? id,
    String? name,
  }) {
    return State(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'] is int? ? json['id'] : 0,
      name: json['name'] is String? ? json['name'] : '',
    );
  }
}
