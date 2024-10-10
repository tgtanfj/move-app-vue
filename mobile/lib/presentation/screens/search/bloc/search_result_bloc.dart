import 'package:bloc/bloc.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/categories_repository.dart';
import 'package:move_app/data/repositories/channels_repository.dart';
import 'package:move_app/data/repositories/search_history_repository.dart';
import 'package:move_app/data/repositories/videos_repository.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_event.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_state.dart';

import '../../../../data/models/search_history_model.dart';
import '../../../../data/repositories/suggestion_repository.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final CategoriesRepository categoriesRepository = CategoriesRepository();
  final ChannelsRepository channelsRepository = ChannelsRepository();
  final VideosRepository videosRepository = VideosRepository();

  SearchResultBloc() : super(SearchResultState.initial()) {
    on<SearchResultInitialEvent>(_onSearchResultInitialEvent);
    on<SearchResultLoadMoreChannelsEvent>(_onSearchResultLoadMoreChannelEvent);
    on<SearchResultLoadPreviousChannelEvent>(
        _onSearchResultLoadPreviousChannelEvent);
    on<SearchSaveHistoryEvent>(_onSearchSaveHistoryEvent);
    on<SearchLoadHistoryEvent>(_onSearchLoadHistoryEvent);
    on<SearchRemoveHistoryEvent>(_onSearchRemoveHistoryEvent);
    on<SearchLoadSuggestionEvent>(_onSearchLoadSuggestionEvent);
  }

  Future<void> _onSearchResultInitialEvent(
      SearchResultInitialEvent event, Emitter<SearchResultState> emit) async {
    emit(state.copyWith(
      status: SearchResultStatus.processing,
      searchQuery: event.searchQuery,
    ));
    if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
      final result = await Future.wait([
        categoriesRepository.searchCategory(
          event.searchQuery!,
        ),
        channelsRepository.searchChannel(event.searchQuery!, 1),
        videosRepository.searchVideo(event.searchQuery!)
      ]);
      final categories = (result[0] is List)
          ? (result[0] as List<CategoryModel>)
          : <CategoryModel>[];
      final channels = (result[1] is List)
          ? (result[1] as List<ChannelModel>)
          : <ChannelModel>[];
      final videos = (result[2] is List)
          ? (result[2] as List<VideoModel>)
          : <VideoModel>[];
      if (categories.isEmpty && channels.isEmpty && videos.isEmpty) {
        emit(state.copyWith(
          status: SearchResultStatus.failure,
        ));
      } else {
        emit(state.copyWith(
          status: SearchResultStatus.success,
          categoryList: categories,
          channelList: channels,
          videoList: videos,
        ));
      }
    } else {
      emit(state.copyWith(status: SearchResultStatus.failure));
    }
  }

  Future<void> _onSearchResultLoadMoreChannelEvent(
      SearchResultLoadMoreChannelsEvent event,
      Emitter<SearchResultState> emit) async {
    var currentPage = state.page ?? 1;
    final totalPages =
        await channelsRepository.getTotalPages(event.searchQuery, currentPage);
    if (totalPages != null) {
      if (currentPage < totalPages!) {
        currentPage++;
        final channels = await channelsRepository.searchChannel(
            event.searchQuery, currentPage);
        emit(state.copyWith(
          channelList: channels,
          page: currentPage,
          totalPages: totalPages,
        ));
      }
    }
  }

  Future<void> _onSearchResultLoadPreviousChannelEvent(
      SearchResultLoadPreviousChannelEvent event,
      Emitter<SearchResultState> emit) async {
    if (state.page != null) {
      if (state.page! > 1) {
        var currentPage = state.page ?? 1;
        currentPage--;
        final channels = await channelsRepository.searchChannel(
            event.searchQuery, currentPage);
        emit(state.copyWith(
          channelList: channels,
          page: currentPage,
        ));
      } else {
        final channels =
            await channelsRepository.searchChannel(event.searchQuery, 1);
        emit(state.copyWith(
          channelList: channels,
        ));
      }
    }
  }

  Future<void> _onSearchLoadHistoryEvent(
      SearchLoadHistoryEvent event, Emitter<SearchResultState> emit) async {
    String token = SharedPrefer.sharedPrefer.getUserToken();
    if (token.isNotEmpty) {
      final history = await SearchHistoryRepository().getSearchHistory();
      history.fold((l) {
        emit(state.copyWith(
          status: SearchResultStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(
          status: SearchResultStatus.success,
          searchHistory: r,
        ));
      });
    }
  }

  Future<void> _onSearchSaveHistoryEvent(
      SearchSaveHistoryEvent event, Emitter<SearchResultState> emit) async {
    final SearchHistoryModel searchHistoryModel =
        SearchHistoryModel(content: event.searchText);
    String token = SharedPrefer.sharedPrefer.getUserToken();
    if (token.isNotEmpty) {
      final history =
          await SearchHistoryRepository().saveSearchHistory(searchHistoryModel);
      history.fold((l) {
        emit(state.copyWith(
          status: SearchResultStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(status: SearchResultStatus.success));
      });
    }
  }

  Future<void> _onSearchRemoveHistoryEvent(
      SearchRemoveHistoryEvent event, Emitter<SearchResultState> emit) async {
    final SearchHistoryModel searchHistoryModel =
        SearchHistoryModel(content: event.searchText);
    String token = SharedPrefer.sharedPrefer.getUserToken();
    if (token.isNotEmpty) {
      final history = await SearchHistoryRepository()
          .deleteSearchHistory(searchHistoryModel);
      history.fold((l) {
        emit(state.copyWith(
          status: SearchResultStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(status: SearchResultStatus.success));
      });
    }
  }

  Future<void> _onSearchLoadSuggestionEvent(
      SearchLoadSuggestionEvent event, Emitter<SearchResultState> emit) async {
    final suggestions =
        await SuggestionRepository().searchSuggestion(event.searchText ?? "");
    suggestions.fold((l) {
      emit(state.copyWith(
        status: SearchResultStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(suggestionList: r));
    });
  }
}
