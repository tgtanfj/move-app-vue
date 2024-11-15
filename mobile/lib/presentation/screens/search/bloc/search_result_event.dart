import 'package:equatable/equatable.dart';

sealed class SearchResultEvent extends Equatable{
  const SearchResultEvent();
}

final class SearchResultInitialEvent extends SearchResultEvent {
  const SearchResultInitialEvent();

  @override
  List<Object?> get props =>
      [
      ];
}
final class SearchResultOnSubmittedEvent extends SearchResultEvent {
  final String? searchQuery;

  const SearchResultOnSubmittedEvent({this.searchQuery});

  @override
  List<Object?> get props =>
      [
        searchQuery,
      ];
}

final class SearchLoadHistoryEvent extends SearchResultEvent {
  @override
  List<Object?> get props => [];
}

final class SearchSaveHistoryEvent extends SearchResultEvent {
  final String searchText;

  const SearchSaveHistoryEvent({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}

final class SearchRemoveHistoryEvent extends SearchResultEvent {
  final String searchText;

  const SearchRemoveHistoryEvent({required this.searchText});

  @override
  List<Object?> get props => [];
}

final class SearchLoadSuggestionEvent extends SearchResultEvent {
  final String? searchText;

  const SearchLoadSuggestionEvent({this.searchText});

  @override
  List<Object?> get props => [];
}

final class SearchResultLoadMoreChannelsEvent extends SearchResultEvent {
  final String searchQuery;

  const SearchResultLoadMoreChannelsEvent({
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [];
}

final class SearchResultLoadPreviousChannelEvent extends SearchResultEvent {
  final String searchQuery;

  const SearchResultLoadPreviousChannelEvent({
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [];
}

final class SearchResultLoadMoreCategoriesEvent extends SearchResultEvent {
  final String searchQuery;

  const SearchResultLoadMoreCategoriesEvent({
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [];
}

final class SearchResultLoadPreviousCategoriesEvent extends SearchResultEvent {
  final String searchQuery;

  const SearchResultLoadPreviousCategoriesEvent({
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [];
}
