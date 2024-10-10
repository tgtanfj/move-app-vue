import 'package:equatable/equatable.dart';

abstract class ViewChannelProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ViewChannelProfileInitialEvent extends ViewChannelProfileEvent {}

class FetchViewChannelProfileEvent extends ViewChannelProfileEvent {}
