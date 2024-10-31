import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/suggestion_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/categories_repository.dart';
import 'package:move_app/data/repositories/channels_repository.dart';
import 'package:move_app/data/repositories/history_repository.dart';
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

    on<SearchResultLoadMoreCategoriesEvent>(
        _onSearchResultLoadMoreCategoriesEvent);
    on<SearchResultLoadPreviousCategoriesEvent>(
        _onSearchResultLoadPreviousCategoriesEvent);

    on<SearchSaveHistoryEvent>(_onSearchSaveHistoryEvent);
    on<SearchLoadHistoryEvent>(_onSearchLoadHistoryEvent);
    on<SearchRemoveHistoryEvent>(_onSearchRemoveHistoryEvent);
    on<SearchLoadSuggestionEvent>(_onSearchLoadSuggestionEvent);
  }

  Future<void> _onSearchResultInitialEvent(
      SearchResultInitialEvent event, Emitter<SearchResultState> emit) async {
    emit(state.copyWith(
      searchQuery: event.searchQuery,
    ));
    if (event.searchQuery != null && event.searchQuery!.trim().isNotEmpty) {
      final result = await Future.wait([
        categoriesRepository.searchCategory(event.searchQuery!.trim(), 1),
        channelsRepository.searchChannel(event.searchQuery!.trim(), 1),
        videosRepository.searchVideo(event.searchQuery!.trim())
      ]);
      (result[0] as Either<String, List<CategoryModel>>).fold((l) {
        emit(state.copyWith(
          status: SearchResultStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(
          categoryList: r,
          status: SearchResultStatus.success,
        ));
      });
      (result[1] as Either<String, List<ChannelModel>>).fold((l) {
        emit(state.copyWith(
          status: SearchResultStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(
            state.copyWith(channelList: r, status: SearchResultStatus.success));
      });
      (result[2] as Either<String, List<VideoModel>>).fold((l) {
        emit(state.copyWith(
          status: SearchResultStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(videoList: r, status: SearchResultStatus.success));
      });
    } else {
      emit(state.copyWith(
        status: SearchResultStatus.failure,
        errorMessage: Constants.failedToLoadVideos,
      ));
    }
  }

  Future<void> _onSearchResultLoadMoreChannelEvent(
      SearchResultLoadMoreChannelsEvent event,
      Emitter<SearchResultState> emit) async {
    var currentPage = state.page ?? 1;
    final totalPages =
        await channelsRepository.getTotalPages(event.searchQuery, currentPage);
    totalPages.fold((l) {
      emit(state.copyWith(
        status: SearchResultStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        totalChannelPages: r,
        status: SearchResultStatus.success,
      ));
    });
    if (state.totalChannelPages != null) {
      if (currentPage < state.totalChannelPages!.toInt()) {
        currentPage++;
        final channels = await channelsRepository.searchChannel(
            event.searchQuery, currentPage);
        channels.fold((l) {
          emit(state.copyWith(
            status: SearchResultStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
              channelList: r,
              page: currentPage,
              totalChannelPages: state.totalChannelPages,
              status: SearchResultStatus.success));
        });
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
        channels.fold((l) {
          emit(state.copyWith(
            status: SearchResultStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
            channelList: r,
            page: currentPage,
          ));
        });
      } else {
        final channels =
            await channelsRepository.searchChannel(event.searchQuery, 1);
        channels.fold((l) {
          emit(state.copyWith(
            status: SearchResultStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
            status: SearchResultStatus.success,
            channelList: r,
          ));
        });
      }
    }
  }

  Future<void> _onSearchResultLoadMoreCategoriesEvent(
      SearchResultLoadMoreCategoriesEvent event,
      Emitter<SearchResultState> emit) async {
    var currentPage = state.currentCategoriesPage ?? 1;
    final totalPages = await categoriesRepository.getTotalCategoriesPages(
        event.searchQuery, currentPage);
    totalPages.fold((l) {
      emit(state.copyWith(
        status: SearchResultStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
          totalCategoriesPages: r, status: SearchResultStatus.success));
    });
    if (state.totalCategoriesPages != null) {
      if (currentPage < state.totalCategoriesPages!.toInt()) {
        currentPage++;
        final categories = await categoriesRepository.searchCategory(
            event.searchQuery, currentPage);
        categories.fold((l) {
          emit(state.copyWith(
            status: SearchResultStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
              categoryList: r,
              currentCategoriesPage: currentPage,
              totalCategoriesPages: state.totalCategoriesPages,
              status: SearchResultStatus.success));
        });
      }
    }
  }

  Future<void> _onSearchResultLoadPreviousCategoriesEvent(
      SearchResultLoadPreviousCategoriesEvent event,
      Emitter<SearchResultState> emit) async {
    if (state.currentCategoriesPage != null) {
      if (state.currentCategoriesPage! > 1) {
        var currentPage = state.currentCategoriesPage ?? 1;
        currentPage--;
        final categories = await categoriesRepository.searchCategory(
            event.searchQuery, currentPage);
        categories.fold((l) {
          emit(state.copyWith(
            status: SearchResultStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
              categoryList: r,
              currentCategoriesPage: currentPage,
              status: SearchResultStatus.success));
        });
      } else {
        final categories =
            await categoriesRepository.searchCategory(event.searchQuery, 1);
        categories.fold((l) {
          emit(state.copyWith(
            status: SearchResultStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
            status: SearchResultStatus.success,
            categoryList: r,
          ));
        });
      }
    }
  }

  Future<void> _onSearchLoadHistoryEvent(
      SearchLoadHistoryEvent event, Emitter<SearchResultState> emit) async {
    String token = SharedPrefer.sharedPrefer.getUserToken();

    if (token.isNotEmpty) {
      final history = await HistoryRepository().getSearchHistory();
      history.fold((l) {
        emit(state.copyWith(
          status: SearchResultStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(
          status: SearchResultStatus.success,
          searchHistory: r,
          categoryList: [],
          channelList: [],
          videoList: [],
        ));
      });
    }
  }

  Future<void> _onSearchSaveHistoryEvent(
      SearchSaveHistoryEvent event, Emitter<SearchResultState> emit) async {
    final SearchHistoryModel searchHistoryModel =
        SearchHistoryModel(content: event.searchText);
    String token = SharedPrefer.sharedPrefer.getUserToken();
    if (token.isNotEmpty && event.searchText.trim().isNotEmpty) {
      final history =
          await HistoryRepository().saveSearchHistory(searchHistoryModel);
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
      final history =
          await HistoryRepository().deleteSearchHistory(searchHistoryModel);
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
      emit(state.copyWith(
        suggestionList: r,
        status: SearchResultStatus.success,
      ));
    });
  }
}
