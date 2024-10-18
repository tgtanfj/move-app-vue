class CategoryModel {
  final int id;
  final String title;

  CategoryModel({
    required this.id,
    required this.title,
  });

  CategoryModel copyWith({
    int? id,
    String? title,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] != null ? json['id'] as int : 0,
        title: json['title'] != null ? json['title'] as String : '',
      );
}
