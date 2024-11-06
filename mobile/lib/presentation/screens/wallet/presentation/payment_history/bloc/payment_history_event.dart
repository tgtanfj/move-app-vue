sealed class PaymentHistoryEvent {
  const PaymentHistoryEvent();
}

final class PaymentHistoryInitialEvent extends PaymentHistoryEvent {
  const PaymentHistoryInitialEvent();
}

final class PaymentHistoryOnTapStartDateEvent extends PaymentHistoryEvent {

  PaymentHistoryOnTapStartDateEvent();
}

final class PaymentHistoryOnTapOutSideEvent extends PaymentHistoryEvent {

  PaymentHistoryOnTapOutSideEvent();
}

final class PaymentHistoryOnTapEndDateEvent extends PaymentHistoryEvent {

  PaymentHistoryOnTapEndDateEvent();
}

final class PaymentHistorySelectionStartDateEvent extends PaymentHistoryEvent {
  final DateTime? startDate;

  PaymentHistorySelectionStartDateEvent({this.startDate});
}

final class PaymentHistorySelectionEndDateEvent extends PaymentHistoryEvent {
  final DateTime? endDate;

  PaymentHistorySelectionEndDateEvent({this.endDate});
}

final class PaymentHistoryLoadMorePageEvent extends PaymentHistoryEvent {

  PaymentHistoryLoadMorePageEvent();
}

final class PaymentHistoryLoadPreviousPageEvent extends PaymentHistoryEvent {

  PaymentHistoryLoadPreviousPageEvent();
}
