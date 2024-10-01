import 'package:equatable/equatable.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();
}

final class MenuInitialEvent extends MenuEvent {
  @override
  List<Object?> get props => [];
}

final class MenuSelectMoreEvent extends MenuEvent {
  final bool isMoreEnable;

  const MenuSelectMoreEvent({required this.isMoreEnable});
  @override
  List<Object?> get props => [];
}
