import 'package:equatable/equatable.dart';

enum SettingStatus {
  initial,
  processing,
  success,
  failure,
}

final class SettingState extends Equatable {
  final SettingStatus? status;

  const SettingState({
    this.status,
  });

  static SettingState initial() => const SettingState(
        status: SettingStatus.initial,
      );

  SettingState copyWith({
    SettingStatus? status,
  }) {
    return SettingState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
      ];
}
