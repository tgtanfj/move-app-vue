import 'package:equatable/equatable.dart';

enum MenuStatus {
  initial,
  hadlogin,
  notlogin,
}

final class MenuState extends Equatable {
  final MenuStatus? status;
  final bool isEnableMore;

  const MenuState({
    this.isEnableMore = false,
    this.status,
  });

  static MenuState initial() => const MenuState(
        status: MenuStatus.initial,
      );

  MenuState copyWith({
    MenuStatus? status,
    bool? isEnableMore,
  }) {
    return MenuState(
        status: status ?? this.status,
        isEnableMore: isEnableMore ?? this.isEnableMore);
  }

  @override
  List<Object?> get props => [status, isEnableMore];
}
