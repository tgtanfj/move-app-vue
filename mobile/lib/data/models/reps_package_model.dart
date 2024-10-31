class RepsPackage {
  final int? numberOfREPs;

  RepsPackage({
    this.numberOfREPs,
  });

  RepsPackage copyWith({
    int? numberOfREPs,
  }) {
    return RepsPackage(
      numberOfREPs: numberOfREPs ?? this.numberOfREPs,
    );
  }

  factory RepsPackage.fromJson(Map<String, dynamic> json) {
    return RepsPackage(
      numberOfREPs: json['numberOfREPs'] is int? ? json['numberOfREPs'] : 0,
    );
  }
}