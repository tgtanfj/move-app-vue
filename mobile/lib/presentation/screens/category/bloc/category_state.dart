import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/category_model.dart';

enum CategoryStatus {
  initial,
  processing,
  success,
  failure,
}

final class CategoryState extends Equatable {
  final CategoryStatus? status;
  final List<CategoryModel> listCategory;

  const CategoryState({
    this.status,
    this.listCategory = const [],
  });

  static CategoryState initial() => const CategoryState(
        status: CategoryStatus.initial,
        listCategory: [],
      );

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryModel>? listCategory,
  }) {
    return CategoryState(
      status: status ?? this.status,
      listCategory: listCategory ?? this.listCategory,
    );
  }

  @override
  List<Object?> get props => [status, listCategory];
}
