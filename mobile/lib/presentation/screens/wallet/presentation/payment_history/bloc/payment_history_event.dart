sealed class PaymentHistoryEvent {
  const PaymentHistoryEvent();
}

final class PaymentHistoryInitialEvent extends PaymentHistoryEvent {
  const PaymentHistoryInitialEvent();
}

final class PaymentHistorySelectionStartDateEvent extends PaymentHistoryEvent {
  final DateTime? startDate;

  PaymentHistorySelectionStartDateEvent({this.startDate});
}

final class PaymentHistorySelectionEndDateEvent extends PaymentHistoryEvent {
  final DateTime? endDate;

  PaymentHistorySelectionEndDateEvent({this.endDate});
}