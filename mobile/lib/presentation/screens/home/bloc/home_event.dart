import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

final class HomeInitialEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
