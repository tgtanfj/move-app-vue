import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

final class HomeInitialEvent extends HomeEvent {
  final bool isLoadingPage;

  const HomeInitialEvent({required this.isLoadingPage});

  @override
  List<Object?> get props => [];
}

