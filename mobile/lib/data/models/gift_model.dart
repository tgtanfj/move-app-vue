class GiftModel {
  int? id;
  int? numberOfREPs;
  String? image;

  GiftModel({
     this.id,
     this.numberOfREPs,
     this.image,
  });

  GiftModel copyWith({
    int? id,
    int? numberOfREPs,
    String? image,
  }) {
    return GiftModel(
      id: id ?? this.id,
      numberOfREPs: numberOfREPs ?? this.numberOfREPs,
      image: image ?? this.image,
    );
  }

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: (json['id'] is int?) ? json['id'] : 0,
      numberOfREPs: (json['numberOfREPs'] is num?) ? json['numberOfREPs'].toInt() : 0,
       image: (json['image'] is String?) ? json['image'] : '',
    );
  }
}
