import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/suggestion_model.dart';

enum HomeStatus {
  initial,
  processing,
  success,
  failure,
}

final class HomeState extends Equatable {
  final HomeStatus? status;


  const HomeState({
    this.status,
  });

  static HomeState initial() => const HomeState(
        status: HomeStatus.initial,

      );

  HomeState copyWith({
    HomeStatus? status,
    bool? isVisible,
    List<String>? searchHistory,
    String? searchQuery,
    SuggestionModel? suggestionList,
  }) {
    return HomeState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
      ];
}
