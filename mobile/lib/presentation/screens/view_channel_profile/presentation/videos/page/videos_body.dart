import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_video_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_feature_description.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/page/sort_and_filter_page.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_state.dart';
import 'package:tuple/tuple.dart';

class VideosBody extends StatefulWidget {
  final ChannelVideoModel? channelVideoModel;
  final List<VideoModel>? videos;
  const VideosBody({super.key, this.channelVideoModel, this.videos});

  @override
  State<VideosBody> createState() => _VideosBodyState();
}

class _VideosBodyState extends State<VideosBody> {
  @override
  Widget build(BuildContext context) {
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
                print(
                    "selectedSortBy: $selectedSortBy selectedLevel: $selectedLevel selectedCategoryId: $selectedCategoryId");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SortAndFilterPage(
                      selectedLevel: selectedLevel,
                      selectedCategory: selectedCategoryId,
                      selectedSortBy: selectedSortBy,
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
                    return const Center(child: Text('Failed to load videos'));
                  }
                  if (state.videos.isEmpty) {
                    return Center(
                      child: Text(
                          '${widget.channelVideoModel?.name ?? 'No'} has not uploaded any videos yet.'),
                    );
                  }

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
                              onTap: () {},
                              child: VideoPoster(
                                height: height * 0.22,
                                isLargePoster: true,
                                thumbnailURL: video.thumbnailURL,
                                videoLength: video.videoLength,
                                numberOfViews: video.numberOfViews,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            VideoFeatureDescription(
                              channelModel: video.channel,
                              categoryModel: video.category,
                              videoModel: video,
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
