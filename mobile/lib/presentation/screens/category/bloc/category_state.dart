import 'package:equatable/equatable.dart';

enum CategoryStatus {
  initial,
  processing,
  success,
  failure,
}

final class CategoryState extends Equatable {
  final CategoryStatus? status;

  const CategoryState({
    this.status,
  });

  static CategoryState initial() => const CategoryState(
        status: CategoryStatus.initial,
      );

  CategoryState copyWith({
    CategoryStatus? status,
  }) {
    return CategoryState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
