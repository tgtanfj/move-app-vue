import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/list_categories.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/home/bloc/home_bloc.dart';
import 'package:move_app/presentation/screens/home/bloc/home_event.dart';
import 'package:move_app/presentation/screens/home/bloc/home_state.dart';
import 'package:move_app/presentation/screens/home/widgets/list_videos_may_u_like.dart';
import 'package:move_app/presentation/screens/home/widgets/slide_show_videos_feature.dart';
import 'package:move_app/presentation/screens/home/widgets/horizontal_divider.dart';

import '../../../../config/theme/app_icons.dart';
import '../../../components/custom_search_box.dart';
import '../../search/page/search_result_body.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        context.read<HomeBloc>().add(HomeLoadSearchHistoryEvent());
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {},
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: state.isVisible
                ? CustomSearchBox(
                    controller: _controller,
                    padding: const EdgeInsets.only(left: 16, bottom: 4, top: 4),
                    borderRadius: 25,
                    autoFocus: true,
                    focusNode: _focusNode,
                    suffix: IconButton(
                      onPressed: () {
                        _controller.clear();
                      },
                      icon: SvgPicture.asset(AppIcons.closeCircle.svgAssetPath),
                      padding: EdgeInsets.zero,
                      iconSize: 28,
                      constraints: const BoxConstraints(),
                      style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    ),
                    onSubmitted: (value) {
                      context
                          .read<HomeBloc>()
                          .add(HomeSaveSearchHistoryEvent(searchText: value));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultBody(
                            searchQuery: value,
                          ),
                        ),
                      );
                    },
                  )
                : AppBarWidget(
                    onSearchButtonTap: () {
                      context.read<HomeBloc>().add(HomeSearchVideoEvent());
                    },
                    prefixButton: () =>
                        Navigator.pushNamed(context, AppRoutes.routeMenu),
                  ),
            backgroundColor: AppColors.white,
            body: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Constants.featured,
                                style:
                                    AppTextStyles.montserratStyle.bold20black),
                            Image.asset(
                              AppImages.headline.webpAssetPath,
                              width: width * 0.5,
                              height: 8.0,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: SlideShowVideosFeature(
                            listVideo: [],
                          )),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const HorizontalDivider(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Constants.category,
                              style: AppTextStyles.montserratStyle.bold20black,
                            ),
                            GestureDetector(
                              child: Text(Constants.viewAll,
                                  style: AppTextStyles
                                      .montserratStyle.regular18tiffanyBlue),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const ListCategories(),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      const HorizontalDivider(),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          Constants.videosYouMayLike,
                          style: AppTextStyles.montserratStyle.bold20black,
                        ),
                      ),
                      const SizedBox(
                        height: 21.0,
                      ),
                      const ListVideosMayULike(),
                    ],
                  ),
                ),
                if (_focusNode.hasFocus &&
                    (state.searchHistory ?? []).isNotEmpty)
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 0,
                    child: Card(
                      elevation: 4,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: (state.searchHistory!.length < 5)
                            ? state.searchHistory?.length
                            : 5,
                        itemBuilder: (context, index) {
                          final searchItem = state.searchHistory![index];
                          return ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(searchItem),
                            trailing: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: const ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                              icon: SvgPicture.asset(
                                AppIcons.closeCircle.svgAssetPath,
                                color: AppColors.chineseSilver,
                                width: 24,
                                height: 24,
                              ),
                              onPressed: () {
                                context.read<HomeBloc>().add(
                                    HomeRemoveSearchHistoryEvent(
                                        searchText: searchItem));
                              },
                            ),
                            onTap: () {
                              _controller.text = searchItem;
                              _focusNode.unfocus();
                              context.read<HomeBloc>().add(
                                  HomeSaveSearchHistoryEvent(
                                      searchText: searchItem));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchResultBody(
                                    searchQuery: searchItem,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
    return Scaffold(
      appBar: AppBarWidget(
        prefixButton: () => Navigator.pushNamed(context, AppRoutes.routeMenu),
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Constants.featured,
                      style: AppTextStyles.montserratStyle.bold20black),
                  Image.asset(
                    AppImages.headline.webpAssetPath,
                    width: width * 0.5,
                    height: 8.0,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: SlideShowVideosFeature(
                  listVideo: [],
                )),
            const SizedBox(
              height: 10.0,
            ),
            const HorizontalDivider(),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Constants.category,
                    style: AppTextStyles.montserratStyle.bold20black,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(Constants.viewAll,
                        style:
                            AppTextStyles.montserratStyle.regular18tiffanyBlue),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const ListCategories(),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const HorizontalDivider(),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                Constants.videosYouMayLike,
                style: AppTextStyles.montserratStyle.bold20black,
              ),
            ),
            const SizedBox(
              height: 21.0,
            ),
            const ListVideosMayULike(),
          ],
        ),
      ),
    );
  }
}
