import 'package:equatable/equatable.dart';

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
  }) {
    return HomeState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [];
}
