import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/rep_model.dart';
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
  final List<RepModel>? reps;
  final bool isStateAtCurrentPage;

  const MenuState({
    this.user,
    this.isEnableMore = false,
    this.status,
    this.reps,
    this.isStateAtCurrentPage = false,
  });

  static MenuState initial() => const MenuState(
        status: MenuStatus.initial,
      );

  MenuState copyWith({
    MenuStatus? status,
    bool? isEnableMore,
    UserModel? user,
    List<RepModel>? reps,
    bool? isStateAtCurrentPage,
  }) {
    return MenuState(
        status: status ?? this.status,
        user: user ?? this.user,
        isEnableMore: isEnableMore ?? this.isEnableMore,
        reps: reps ?? this.reps,
        isStateAtCurrentPage:
            isStateAtCurrentPage ?? this.isStateAtCurrentPage);
  }

  @override
  List<Object?> get props =>
      [status, isEnableMore, user, reps, isStateAtCurrentPage];
}
