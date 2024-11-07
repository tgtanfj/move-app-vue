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
  final int? currentCategoriesPage;
  final List<SearchHistoryModel>? searchHistory;
  final List<CategoryModel> categoryList;
  final List<ChannelModel> channelList;
  final List<VideoModel> videoList;
  final SuggestionModel? suggestionList;
  final int? totalCategoriesPages;
  final int? totalChannelPages;
  final String? searchResultFound;
  final String? searchDifferenceKeyword;
  final bool isShowSectionBar;

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
    this.totalCategoriesPages,
    this.totalChannelPages,
    this.currentCategoriesPage,
    this.searchResultFound,
    this.isShowSectionBar = false,
    this.searchDifferenceKeyword,
  });

  static SearchResultState initial() => const SearchResultState(
        status: SearchResultStatus.initial,
        searchQuery: '',
        errorMessage: '',
        page: 1,
        currentCategoriesPage: 1,
        searchHistory: [],
        categoryList: [],
        channelList: [],
        videoList: [],
        searchResultFound: '',
        isShowSectionBar: false,
        searchDifferenceKeyword: '',
      );

  SearchResultState copyWith({
    SearchResultStatus? status,
    String? searchQuery,
    String? errorMessage,
    int? page,
    int? currentCategoriesPage,
    int? totalCategoriesPages,
    int? totalChannelPages,
    List<SearchHistoryModel>? searchHistory,
    List<CategoryModel>? categoryList,
    List<ChannelModel>? channelList,
    List<VideoModel>? videoList,
    SuggestionModel? suggestionList,
    String? searchResultFound,
    bool? isShowSectionBar,
    String? searchDifferenceKeyword,
  }) {
    return SearchResultState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      currentCategoriesPage:
          currentCategoriesPage ?? this.currentCategoriesPage,
      searchHistory: searchHistory ?? this.searchHistory,
      categoryList: categoryList ?? this.categoryList,
      channelList: channelList ?? this.channelList,
      videoList: videoList ?? this.videoList,
      suggestionList: suggestionList ?? this.suggestionList,
      totalCategoriesPages: totalCategoriesPages ?? this.totalCategoriesPages,
      totalChannelPages: totalChannelPages ?? this.totalChannelPages,
      searchResultFound: searchResultFound ?? this.searchResultFound,
      isShowSectionBar: isShowSectionBar ?? this.isShowSectionBar,
      searchDifferenceKeyword:
          searchDifferenceKeyword ?? this.searchDifferenceKeyword,
    );
  }

  @override
  List<Object?> get props => [
        searchQuery,
        page,
        currentCategoriesPage,
        totalCategoriesPages,
        totalChannelPages,
        errorMessage,
        searchHistory,
        categoryList,
        channelList,
        videoList,
        suggestionList,
        searchResultFound,
        status,
        isShowSectionBar,
        searchDifferenceKeyword,
      ];
}
