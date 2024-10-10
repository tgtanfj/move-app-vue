import 'package:equatable/equatable.dart';

abstract class VideosEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideosInitialEvent extends VideosEvent {}

class FetchVideosEvent extends VideosEvent {}
