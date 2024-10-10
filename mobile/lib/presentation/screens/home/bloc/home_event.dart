import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

final class HomeInitialEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

final class HomeSearchVideoEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

final class HomeLoadSearchHistoryEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

final class HomeSaveSearchHistoryEvent extends HomeEvent {
  final String searchText;

  const HomeSaveSearchHistoryEvent({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}

final class HomeRemoveSearchHistoryEvent extends HomeEvent {
  final String searchText;

  const HomeRemoveSearchHistoryEvent({required this.searchText});

  @override
  List<Object?> get props => [];
}
