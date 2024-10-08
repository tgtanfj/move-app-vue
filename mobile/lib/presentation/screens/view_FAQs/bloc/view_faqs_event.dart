import 'package:equatable/equatable.dart';

abstract class ViewFaqsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchFaqsEvent extends ViewFaqsEvent {}

class LoadMoreFaqsEvent extends ViewFaqsEvent {}
