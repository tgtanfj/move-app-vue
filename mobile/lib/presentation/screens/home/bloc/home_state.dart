import 'package:equatable/equatable.dart';

enum HomeStatus {
  initial,
  processing,
  success,
  failure,
}

final class HomeState extends Equatable {
  final HomeStatus? status;
  final bool isVisible;
  final List<String>? searchHistory;

  const HomeState({
    this.status,
    this.isVisible = false,
    this.searchHistory,
  });

  static HomeState initial() => const HomeState(
        status: HomeStatus.initial,
        isVisible: false,
        searchHistory: [],
      );

  HomeState copyWith({
    HomeStatus? status,
    bool? isVisible,
    List<String>? searchHistory,
  }) {
    return HomeState(
      status: status ?? this.status,
      isVisible: isVisible ?? this.isVisible,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }

  @override
  List<Object?> get props => [
        isVisible,
        searchHistory,
      ];
}
