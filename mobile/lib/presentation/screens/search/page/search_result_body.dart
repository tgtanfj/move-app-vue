import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_search_box.dart';
import 'package:move_app/presentation/components/custom_section_title.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_bloc.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_event.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_state.dart';
import 'package:move_app/presentation/screens/search/widgets/list_channels.dart';
import 'package:move_app/presentation/screens/search/widgets/list_search_result_categories.dart';
import 'package:move_app/presentation/screens/search/widgets/list_search_result_video.dart';
import 'package:move_app/presentation/screens/search/widgets/search_history_widgets.dart';
import 'package:move_app/presentation/screens/search/widgets/suggestion_search_box.dart';

class SearchResultBody extends StatefulWidget {
  final String? searchQuery;
  final int? page;

  const SearchResultBody({super.key, this.searchQuery, this.page});

  @override
  State<SearchResultBody> createState() => _SearchResultBodyState();
}

class _SearchResultBodyState extends State<SearchResultBody> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        context.read<SearchResultBloc>().add(SearchLoadHistoryEvent());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchResultBloc, SearchResultState>(
      listener: (context, state) {
        (state.status == SearchResultStatus.processing)
            ? EasyLoading.show()
            : EasyLoading.dismiss();
      },
      child: BlocBuilder<SearchResultBloc, SearchResultState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomSearchBox(
              controller: _controller,
              padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
              borderRadius: 25,
              autoFocus: true,
              focusNode: _focusNode,
              suffix: IconButton(
                onPressed: () {
                  _controller.clear();
                  _focusNode.requestFocus();
                  context
                      .read<SearchResultBloc>()
                      .add(SearchLoadHistoryEvent());
                },
                icon: SvgPicture.asset(AppIcons.closeCircle.svgAssetPath),
                padding: EdgeInsets.zero,
                iconSize: 28,
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
              onValueChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  context
                      .read<SearchResultBloc>()
                      .add(SearchLoadSuggestionEvent(searchText: value));
                });
              },
              onSubmitted: (value) {
                if (_controller.text.trim().isNotEmpty) {
                  context
                      .read<SearchResultBloc>()
                      .add(SearchSaveHistoryEvent(searchText: value));
                  _focusNode.unfocus();
                  context.read<SearchResultBloc>().add(
                      SearchResultOnSubmittedEvent(
                          searchQuery: _controller.text.trim()));
                } else {
                  _focusNode.requestFocus();
                }
              },
            ),
            backgroundColor: AppColors.white,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            (state.isShowSectionBar == true)
                                ? CustomSectionTitle(
                                    title: (state.categoryList.isEmpty &&
                                            state.videoList.isEmpty &&
                                            state.channelList.isEmpty)
                                        ? Constants.noSearchResults
                                        : Constants.searchResults)
                                : const SizedBox(),
                            const SizedBox(
                              height: 24,
                            ),
                            (state.categoryList.isEmpty &&
                                    state.videoList.isEmpty &&
                                    state.channelList.isEmpty)
                                ? Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.38,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      state.searchResultFound ??
                                                          "",
                                                  style: AppTextStyles
                                                      .montserratStyle
                                                      .bold14Black),
                                              const TextSpan(text: " "),
                                              TextSpan(
                                                  text: state.searchQuery,
                                                  style: AppTextStyles
                                                      .montserratStyle
                                                      .regular14Black
                                                      .copyWith(
                                                          fontStyle: FontStyle
                                                              .italic)),
                                            ],
                                          ),
                                        ),
                                        Text(
                                            state.searchDifferenceKeyword ?? "",
                                            style: AppTextStyles
                                                .montserratStyle.regular14Black
                                                .copyWith(
                                                    fontStyle:
                                                        FontStyle.italic)),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      (state.categoryList.isNotEmpty)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Constants.categories,
                                                  style: AppTextStyles
                                                      .montserratStyle
                                                      .bold16Black,
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  child:
                                                      ListSearchResultCategories(
                                                    categoryList:
                                                        state.categoryList,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                SearchResultBloc>()
                                                            .add(SearchResultLoadPreviousCategoriesEvent(
                                                                searchQuery:
                                                                    state.searchQuery ??
                                                                        ""));
                                                      },
                                                      icon: const Icon(Icons
                                                          .navigate_before),
                                                      color:
                                                          (state.currentCategoriesPage ==
                                                                  1)
                                                              ? AppColors
                                                                  .chineseSilver
                                                              : AppColors
                                                                  .tiffanyBlue,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                SearchResultBloc>()
                                                            .add(SearchResultLoadMoreCategoriesEvent(
                                                                searchQuery:
                                                                    state.searchQuery ??
                                                                        ""));
                                                      },
                                                      icon: const Icon(
                                                          Icons.navigate_next),
                                                      color: (state
                                                                  .currentCategoriesPage ==
                                                              state
                                                                  .totalCategoriesPages)
                                                          ? AppColors
                                                              .chineseSilver
                                                          : AppColors
                                                              .tiffanyBlue,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      (state.channelList.isNotEmpty)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (state.categoryList.isNotEmpty)
                                                    ? const Divider(height: 1)
                                                    : const SizedBox(),
                                                const SizedBox(height: 16),
                                                Text(
                                                  Constants.channels,
                                                  style: AppTextStyles
                                                      .montserratStyle
                                                      .bold16Black,
                                                ),
                                                const SizedBox(height: 16),
                                                ListChannels(
                                                    channelList:
                                                        state.channelList),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                SearchResultBloc>()
                                                            .add(SearchResultLoadPreviousChannelEvent(
                                                                searchQuery:
                                                                    state.searchQuery ??
                                                                        ""));
                                                      },
                                                      icon: const Icon(Icons
                                                          .navigate_before),
                                                      color: (state.page == 1)
                                                          ? AppColors
                                                              .chineseSilver
                                                          : AppColors
                                                              .tiffanyBlue,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                SearchResultBloc>()
                                                            .add(SearchResultLoadMoreChannelsEvent(
                                                                searchQuery:
                                                                    state.searchQuery ??
                                                                        ""));
                                                      },
                                                      icon: const Icon(
                                                          Icons.navigate_next),
                                                      color: (state.page ==
                                                              state
                                                                  .totalChannelPages)
                                                          ? AppColors
                                                              .chineseSilver
                                                          : AppColors
                                                              .tiffanyBlue,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            )
                                          : const SizedBox(),
                                      (state.videoList.isNotEmpty)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (state.categoryList
                                                            .isNotEmpty ||
                                                        state.channelList
                                                            .isNotEmpty)
                                                    ? const Divider(height: 1)
                                                    : const SizedBox(),
                                                const SizedBox(height: 16),
                                                Text(
                                                  Constants.videos,
                                                  style: AppTextStyles
                                                      .montserratStyle
                                                      .bold16Black,
                                                ),
                                                const SizedBox(height: 16),
                                                ListSearchResultVideo(
                                                  videoList: state.videoList,
                                                  channelList:
                                                      state.channelList,
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_focusNode.hasFocus)
                    Positioned(
                      left: 16,
                      right: 16,
                      top: 0,
                      child: (_controller.text.trim().isNotEmpty &&
                              state.suggestionList != null &&
                              state.searchHistory != null)
                          ? Card(
                              elevation: 4,
                              color: AppColors.white,
                              child: SuggestionSearchBox(
                                suggestionModel: state.suggestionList,
                                resultSearchText: _controller.text,
                              ),
                            )
                          : Card(
                              elevation: 4,
                              color: AppColors.white,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: (state.searchHistory!.length < 5)
                                    ? state.searchHistory?.length
                                    : 5,
                                itemBuilder: (context, index) {
                                  final searchItem =
                                      state.searchHistory![index];
                                  return SearchHistoryWidgets(
                                    searchItem: searchItem.content ?? "",
                                    onPress: () {
                                      context.read<SearchResultBloc>().add(
                                            SearchRemoveHistoryEvent(
                                                searchText:
                                                    searchItem.content ?? ""),
                                          );
                                      context
                                          .read<SearchResultBloc>()
                                          .add(SearchLoadHistoryEvent());
                                    },
                                    onTap: () {
                                      _focusNode.unfocus();
                                      context.read<SearchResultBloc>().add(
                                          SearchResultOnSubmittedEvent(
                                              searchQuery: searchItem.content));
                                      _controller.text =
                                          searchItem.content ?? "";
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
