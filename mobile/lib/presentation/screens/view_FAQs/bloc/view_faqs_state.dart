import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/faqs_model.dart';

abstract class ViewFaqsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ViewFaqsInitialState extends ViewFaqsState {}

class ViewFaqsLoadingState extends ViewFaqsState {}

class ViewFaqsLoadedState extends ViewFaqsState {
  final List<FaqModel> faqs;
  ViewFaqsLoadedState({required this.faqs});
  @override
  List<Object> get props => [faqs];
}

class ViewFaqsErrorState extends ViewFaqsState {
  final String errorMessage;
  ViewFaqsErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
