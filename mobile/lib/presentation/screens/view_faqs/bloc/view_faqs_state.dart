import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/faqs_model.dart';

enum ViewFaqsStatus {
  initial,
  loaded,
  loading,
  error,
}

final class ViewFaqsState extends Equatable {
  final ViewFaqsStatus? status;
  final List<FaqModel>? faqs;
  final String? errorMessage;
  final Map<int, bool>? isExpanded;
  const ViewFaqsState(
      {this.status, this.faqs, this.errorMessage, this.isExpanded});

  static ViewFaqsState initialState() => const ViewFaqsState(
        status: ViewFaqsStatus.initial,
      );

  ViewFaqsState copyWith({
    ViewFaqsStatus? status,
    List<FaqModel>? faqs,
    String? errorMessage,
    Map<int, bool>? isExpanded,
  }) {
    return ViewFaqsState(
      status: status ?? this.status,
      faqs: faqs ?? this.faqs,
      errorMessage: errorMessage ?? this.errorMessage,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [status, faqs, errorMessage, isExpanded];
}
