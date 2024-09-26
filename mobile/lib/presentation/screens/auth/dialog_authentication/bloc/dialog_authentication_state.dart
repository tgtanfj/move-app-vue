import 'package:equatable/equatable.dart';

class DialogAuthenticationState extends Equatable {
  final int currentPage;

  const DialogAuthenticationState({
    this.currentPage = 0,
  });

  DialogAuthenticationState copyWith({
    int? currentPage,
  }) {
    return DialogAuthenticationState(
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [currentPage];
}
