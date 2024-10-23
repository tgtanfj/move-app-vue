import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum PaymentHistoryStatus {
  initial,
  processing,
  success,
  failure,
}

final class PaymentHistoryState extends Equatable {
  final PaymentHistoryStatus? status;
  final bool? isPickedStartDate;
  final bool? isPickedEndDate;
  final DateTime? startDate;
  final DateTime? endDate;

  const PaymentHistoryState({
    this.status,
    this.isPickedStartDate,
    this.isPickedEndDate,
    this.startDate,
    this.endDate,
  });

  static PaymentHistoryState initial() => PaymentHistoryState(
        status: PaymentHistoryStatus.initial,
        isPickedStartDate: false,
        isPickedEndDate: false,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now(),
      );

  PaymentHistoryState copyWith({
    PaymentHistoryStatus? status,
    bool? isPickedStartDate,
    bool? isPickedEndDate,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return PaymentHistoryState(
      status: status ?? this.status,
      isPickedStartDate: isPickedStartDate ?? this.isPickedStartDate,
      isPickedEndDate: isPickedEndDate ?? this.isPickedEndDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isPickedStartDate,
        isPickedEndDate,
        startDate,
        endDate,
      ];
}
