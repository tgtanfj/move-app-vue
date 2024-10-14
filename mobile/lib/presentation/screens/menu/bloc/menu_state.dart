import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/user_model.dart';

enum MenuStatus {
  initial,
  hadlogin,
  notlogin,
  failure,
}

final class MenuState extends Equatable {
  final MenuStatus? status;
  final bool isEnableMore;
  final UserModel? user;

  const MenuState({
    this.user,
    this.isEnableMore = false,
    this.status,
  });

  static MenuState initial() => const MenuState(
        status: MenuStatus.initial,
      );

  MenuState copyWith({
    MenuStatus? status,
    bool? isEnableMore,
    UserModel? user,
  }) {
    return MenuState(
        status: status ?? this.status,
        user: user ?? this.user,
        isEnableMore: isEnableMore ?? this.isEnableMore);
  }

  @override
  List<Object?> get props => [status, isEnableMore];
}
