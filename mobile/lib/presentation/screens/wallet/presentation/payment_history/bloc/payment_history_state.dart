
import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/payment_model.dart';

enum PaymentHistoryStatus {
  initial,
  processing,
  success,
  failure,
}

final class PaymentHistoryState extends Equatable {
  final PaymentHistoryStatus? status;
  final String? errorMessage;
  final bool isPickedStartDate;
  final bool isPickedEndDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<PaymentModel>? paymentHistoryList;
  final int? currentPage;
  final PaymentModel? totalResult;
  final int? startResult;
  final int? endResult;

  const PaymentHistoryState({
    this.status,
    this.errorMessage,
    this.isPickedStartDate = false,
    this.isPickedEndDate = false,
    this.startDate,
    this.endDate,
    this.paymentHistoryList,
    this.currentPage,
    this.totalResult,
    this.startResult,
    this.endResult,
  });

  static PaymentHistoryState initial() => PaymentHistoryState(
        status: PaymentHistoryStatus.initial,
        isPickedStartDate: false,
        isPickedEndDate: false,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now(),
        currentPage: 1,
        startResult: 1,
      );

  PaymentHistoryState copyWith({
    PaymentHistoryStatus? status,
    String? errorMessage,
    bool? isPickedStartDate,
    bool? isPickedEndDate,
    DateTime? startDate,
    DateTime? endDate,
    List<PaymentModel>? paymentHistoryList,
    int? totalPages,
    int? currentPage,
    PaymentModel? total,
    int? take,
    int? startResult,
    int? endResult,
  }) {
    return PaymentHistoryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPickedStartDate: isPickedStartDate ?? this.isPickedStartDate,
      isPickedEndDate: isPickedEndDate ?? this.isPickedEndDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paymentHistoryList: paymentHistoryList ?? this.paymentHistoryList,
      currentPage: currentPage ?? this.currentPage,
      totalResult: total ?? this.totalResult,
      startResult: startResult ?? this.startResult,
      endResult: endResult ?? this.endResult,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isPickedStartDate,
        isPickedEndDate,
        startDate,
        endDate,
        paymentHistoryList,
        currentPage,
        totalResult,
        startResult,
        endResult,
      ];
}
