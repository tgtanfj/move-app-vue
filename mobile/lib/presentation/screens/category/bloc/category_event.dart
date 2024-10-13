import 'package:equatable/equatable.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();
}

final class CategoryInitialEvent extends CategoryEvent {
  @override
  List<Object?> get props => [];
}



