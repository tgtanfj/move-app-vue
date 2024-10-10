import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/search_history_model.dart';
import 'package:move_app/data/models/video_model.dart';

import '../../../../data/models/suggestion_model.dart';

enum SearchResultStatus {
  initial,
  processing,
  success,
  failure,
}

final class SearchResultState extends Equatable {
  final SearchResultStatus? status;
  final String? searchQuery;
  final String? errorMessage;
  final int? page;
  final List<SearchHistoryModel>? searchHistory;
  final List<CategoryModel> categoryList;
  final List<ChannelModel> channelList;
  final List<VideoModel> videoList;
  final SuggestionModel? suggestionList;
  final int? totalPages;

  const SearchResultState({
    this.status,
    this.searchQuery,
    this.errorMessage,
    this.page,
    this.searchHistory,
    required this.categoryList,
    required this.channelList,
    required this.videoList,
    this.suggestionList,
    this.totalPages,
  });

  static SearchResultState initial() =>
      const SearchResultState(
        status: SearchResultStatus.initial,
        searchQuery: '',
        errorMessage: '',
        page: 1,
        searchHistory: [],
        categoryList: [],
        channelList: [],
        videoList: [],
      );

  SearchResultState copyWith({
    SearchResultStatus? status,
    String? searchQuery,
    String? errorMessage,
    int? page,
    int? totalPages,
    List<SearchHistoryModel>? searchHistory,
    List<CategoryModel>? categoryList,
    List<ChannelModel>? channelList,
    List<VideoModel>? videoList,
    SuggestionModel? suggestionList,
  }) {
    return SearchResultState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      searchHistory: searchHistory ?? this.searchHistory,
      categoryList: categoryList ?? this.categoryList,
      channelList: channelList ?? this.channelList,
      videoList: videoList ?? this.videoList,
      suggestionList: suggestionList ?? this.suggestionList,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props =>
      [
        searchQuery,
        page,
        totalPages,
        errorMessage,
        searchHistory,
        categoryList,
        channelList,
        videoList,
        suggestionList,
      ];
}
