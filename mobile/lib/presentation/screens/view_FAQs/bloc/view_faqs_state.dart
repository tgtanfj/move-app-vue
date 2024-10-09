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
  const ViewFaqsState({this.status, this.faqs, this.errorMessage});

  static ViewFaqsState initialState() => const ViewFaqsState(
        status: ViewFaqsStatus.initial,
      );

  ViewFaqsState copyWith({
    ViewFaqsStatus? status,
    List<FaqModel>? faqs,
    String? errorMessage,
  }) {
    return ViewFaqsState(
      status: status ?? this.status,
      faqs: faqs ?? this.faqs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, faqs, errorMessage];
}
