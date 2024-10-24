import 'package:equatable/equatable.dart';

abstract class ViewFaqsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ViewFaqsInitialEvent extends ViewFaqsEvent {}

class FetchFaqsEvent extends ViewFaqsEvent {}

class LoadMoreFaqsEvent extends ViewFaqsEvent {}

class ViewFaqsClickEvent extends ViewFaqsEvent {
  final int faqId;

  ViewFaqsClickEvent({required this.faqId});
  @override
  List<Object> get props => [faqId];
}
