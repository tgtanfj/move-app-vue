class ThumbnailsModel {
  final String? image;

  ThumbnailsModel({
    this.image,
  });

  ThumbnailsModel copyWith({
    String? image,
  }) {
    return ThumbnailsModel(
      image: image ?? this.image,
    );
  }

  factory ThumbnailsModel.fromJson(Map<String, dynamic> json) {
    return ThumbnailsModel(
      image: json['image'] is String? ? json['image'] : '',
    );
  }
}