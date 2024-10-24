import 'package:equatable/equatable.dart';

enum BuyRepStatus {
  initial,
  processing,
  success,
  failure,
}

final class BuyRepState extends Equatable {
  final BuyRepStatus? status;
  final bool isSavePayment;

  const BuyRepState({
    this.status,
    this.isSavePayment = false,
  });

  static BuyRepState initial() => const BuyRepState(
        status: BuyRepStatus.initial,
      );

  BuyRepState copyWith({
    BuyRepStatus? status,
    bool? isSavePayment,
  }) {
    return BuyRepState(
      status: status ?? this.status,
      isSavePayment: isSavePayment ?? this.isSavePayment,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isSavePayment,
      ];
}
