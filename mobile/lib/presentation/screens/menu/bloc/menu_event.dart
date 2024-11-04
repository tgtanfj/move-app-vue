import 'package:equatable/equatable.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();
}

final class MenuInitialEvent extends MenuEvent {
  final bool isStateAtCurrentPage;

  const MenuInitialEvent({required this.isStateAtCurrentPage});

  @override
  List<Object?> get props => [isStateAtCurrentPage];
}

final class MenuSelectMoreEvent extends MenuEvent {
  final bool isMoreEnable;

  const MenuSelectMoreEvent({required this.isMoreEnable});

  @override
  List<Object?> get props => [];
}

final class MenuLogoutSuccessEvent extends MenuEvent {
  const MenuLogoutSuccessEvent();

  @override
  List<Object?> get props => [];
}
