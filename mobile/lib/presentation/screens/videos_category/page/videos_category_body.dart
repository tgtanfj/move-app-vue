import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_feature_description.dart';
import 'package:move_app/presentation/screens/videos_category/bloc/videos_category_bloc.dart';
import 'package:move_app/presentation/screens/videos_category/bloc/videos_category_event.dart';
import 'package:move_app/presentation/screens/videos_category/bloc/videos_category_state.dart';
import 'package:move_app/utils/util_number_format.dart';

class VideosCategoryBody extends StatefulWidget {
  const VideosCategoryBody({super.key});

  @override
  State<VideosCategoryBody> createState() => _VideosCategoryBodyState();
}

class _VideosCategoryBodyState extends State<VideosCategoryBody> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const AppBarWidget(),
      body: BlocConsumer<VideosCategoryBloc, VideosCategoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            return LazyLoadScrollView(
              onEndOfPage: () {
                context
                    .read<VideosCategoryBloc>()
                    .add(const VideosCategoryLoadMoreEvent());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.listVideoCategory?.first.categories?.title ??
                              '',
                          style: AppTextStyles.montserratStyle.bold20Black,
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Image.asset(
                          AppImages.headline.webpAssetPath,
                          width: width * 0.5,
                          height: 8.0,
                        )
                      ],
                    ),
                    Flexible(
                      child: ListView.separated(
                        itemCount: state.listVideoCategory?.length ?? 0,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 10.0,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width - 40.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                VideoPoster(
                                  image: state
                                      .listVideoCategory?[index].thumbnailURL,
                                  height: height * 0.21,
                                  isLargePoster: true,
                                  duration: state.listVideoCategory?[index]
                                          .durationsVideo
                                          ?.toDurationFormat() ??
                                      '00:00',
                                  numberOfViews: state
                                      .listVideoCategory?[index].numberOfViews
                                      ?.toCompactViewCount(),
                                  onTap: () {},
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                VideoFeatureDescription(
                                  onTapToVideoDetail: () {},
                                  videoModel: state.listVideoCategory?[index],
                                  channelModel:
                                      state.listVideoCategory?[index].channel,
                                  category: state
                                      .listVideoCategory?[index].categories,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
