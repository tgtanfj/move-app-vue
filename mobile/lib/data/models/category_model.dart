class CategoryModel {
  final int? id;
  final String? title;
  final String? image;
  final int? numberOfViews;

  CategoryModel({
    this.id,
    this.title,
    this.image,
    this.numberOfViews,
  });

  CategoryModel copyWith({
    int? id,
    String? title,
    String? image,
    int? numberOfViews,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      numberOfViews: numberOfViews ?? this.numberOfViews,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] is int?) ? json['id'] : 0,
      title: (json['title'] is String?) ? json['title'] : '',
      image: (json['image'] is String?) ? json['image'] : '',
      numberOfViews:
          (json['numberOfViews'] is int?) ? json['numberOfViews'] : 0,
    );
  }
}
