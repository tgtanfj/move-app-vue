import 'package:equatable/equatable.dart';

class DialogAuthenticationState extends Equatable {
  final bool isShowLoginPage;

  const DialogAuthenticationState({
    this.isShowLoginPage = true,
  });

  DialogAuthenticationState copyWith({
    bool? isShowLoginPage,
  }) {
    return DialogAuthenticationState(
      isShowLoginPage: isShowLoginPage ?? this.isShowLoginPage,
    );
  }

  @override
  List<Object?> get props => [isShowLoginPage];
}
