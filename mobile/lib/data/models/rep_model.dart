class RepModel {
  final int? id;
  final int? numberOfREPs;
  final double? price;

  RepModel({
    this.id,
    this.numberOfREPs,
    this.price,
  });

  RepModel copyWith({
    int? id,
    int? numberOfREPs,
    double? price,
  }) {
    return RepModel(
      id: id ?? this.id,
      numberOfREPs: numberOfREPs ?? this.numberOfREPs,
      price: price ?? this.price,
    );
  }

  factory RepModel.fromJson(Map<String, dynamic> json) {
    return RepModel(
      id: json['id'] is int? ? json['id'] : 0,
      numberOfREPs: json['numberOfREPs'] is int? ? json['numberOfREPs'] : 0,
      price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
    );
  }
}
