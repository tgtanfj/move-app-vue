import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_feature_description.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_page.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/page/sort_and_filter_page.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_state.dart';
import 'package:move_app/utils/util_number_format.dart';
import 'package:tuple/tuple.dart';

class VideosBody extends StatefulWidget {
  final ChannelModel? channelModel;
  final List<VideoModel>? videos;

  const VideosBody({super.key, this.channelModel, this.videos});
  @override
  State<VideosBody> createState() => _VideosBodyState();
}

class _VideosBodyState extends State<VideosBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            CustomButton(
              width: MediaQuery.of(context).size.width - 215,
              prefix: SvgPicture.asset(
                AppIcons.filterList.svgAssetPath,
                width: 24,
                height: 18,
              ),
              sizedBox: const SizedBox(width: 4),
              title: Constants.sortFilter,
              titleStyle: AppTextStyles.montserratStyle.bold14White,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              onTap: () {
                final selectedLevel =
                    context.read<VideosBloc>().state.selectedLevel;
                final selectedCategoryId =
                    context.read<VideosBloc>().state.selectedCategory;
                final selectedSortBy =
                    context.read<VideosBloc>().state.selectedSortBy;
                final channelId = context.read<VideosBloc>().state.channelId;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SortAndFilterPage(
                      selectedLevel: selectedLevel,
                      selectedCategory: selectedCategoryId,
                      selectedSortBy: selectedSortBy,
                      channelId: channelId,
                    ),
                  ),
                ).then((onValue) {
                  if (onValue != null) {
                    final data = onValue as Tuple3<WorkoutLevelType,
                        CategoryModel?, SortAndFilterType>;
                    context.read<VideosBloc>().add(VideoSortedAndFiledEvent(
                          selectedLevel: data.item1,
                          selectedSortBy: data.item3,
                          selectedCategory: data.item2,
                        ));
                  }
                });
              },
              backgroundColor: AppColors.tiffanyBlue,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<VideosBloc, VideosState>(
                builder: (context, state) {
                  if (state.status == VideosStatus.failure) {
                    return const Center(
                        child: Text(Constants.failedToLoadVideos));
                  }
                  if (state.videos.isEmpty) {
                    return const Center(
                      child: Text(Constants.noDataAvailable),
                    );
                  } else {
                    return LazyLoadScrollView(
                      onEndOfPage: () {
                        context.read<VideosBloc>().add(LoadMoreVideosEvent());
                      },
                      child: ListView.builder(
                        itemCount: state.isLoading ?? false
                            ? (state.videos.length + 1)
                            : state.videos.length,
                        itemBuilder: (context, index) {
                          if (index == state.videos.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final video = state.videos[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoDetailPage(
                                        videoId: video.id ?? 0,
                                      ),
                                    ),
                                  );
                                },
                                child: VideoPoster(
                                  height: height * 0.22,
                                  isViewText: true,
                                  isDurationText: true,
                                  image: video.thumbnailURL,
                                  duration:
                                      video.videoLength?.toDurationFormat() ??
                                          '00:00',
                                  numberOfViews:
                                      video.numberOfViews?.toCompactViewCount(),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              VideoFeatureDescription(
                                onTapToVideoDetail: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoDetailPage(
                                      videoId: video.id ?? 0,
                                    ),
                                  ),
                                ),
                                channelModel: video.channel,
                                category: video.category,
                                videoModel: video,
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
