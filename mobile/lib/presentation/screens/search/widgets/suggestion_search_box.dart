import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/suggestion_model.dart';
import 'package:move_app/presentation/components/avatar.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_page.dart';
import 'package:move_app/presentation/screens/videos_category/page/videos_category_page.dart';
import 'package:move_app/presentation/screens/view_channel_profile/page/view_channel_profile_page.dart';

class SuggestionSearchBox extends StatelessWidget {
  final SuggestionModel? suggestionModel;
  final String? resultSearchText;

  const SuggestionSearchBox({
    super.key,
    this.suggestionModel,
    this.resultSearchText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (suggestionModel?.topCategory != null)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: suggestionModel?.topCategory?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                      suggestionModel?.topCategory?[index].image ?? "",
                      height: 40,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.hiitCategory.pngAssetPath,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        );
                      },
                    ),
                    title: Text(
                      suggestionModel?.topCategory?[index].title ?? "",
                      style: AppTextStyles.montserratStyle.regular14Black,
                    ),
                    trailing: Text(
                      Constants.categories,
                      style:
                          AppTextStyles.montserratStyle.regular12Black.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideosCategoryPage(
                            categoryId:
                                suggestionModel?.topCategory?[index].id ?? 0,
                          ),
                        ),
                      );
                    },
                  );
                })
            : const SizedBox(),
        (suggestionModel?.topInstructors != null)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: suggestionModel?.topInstructors?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Avatar(
                        imageUrl:
                            suggestionModel?.topInstructors?[index].image ?? "",
                        widthAvatar: 40,
                        heightAvatar: 40,
                        radiusAvatar: 50),
                    title: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        Text(
                          suggestionModel?.topInstructors?[index].name ?? "",
                          style: AppTextStyles.montserratStyle.regular14Black,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        (suggestionModel?.topInstructors?[index].isBlueBadge ??
                                false)
                            ? SvgPicture.asset(AppIcons.blueStick.svgAssetPath)
                            : const SizedBox(),
                      ],
                    ),
                    trailing: Text(
                      Constants.instructors,
                      style:
                          AppTextStyles.montserratStyle.regular12Black.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewChannelProfilePage(
                            idChannel:
                                suggestionModel?.topInstructors?[index].id ?? 0,
                          ),
                        ),
                      );
                    },
                  );
                })
            : const SizedBox(),
        (suggestionModel?.topVideos != null)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: suggestionModel?.topVideos?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Avatar(
                        imageUrl: suggestionModel?.topVideos?[index]
                                .thumbnailsModel?.firstOrNull?.image ??
                            "",
                        widthAvatar: 40,
                        heightAvatar: 40,
                        radiusAvatar: 50),
                    title: Text(
                      suggestionModel?.topVideos?[index].title ?? "",
                      style: AppTextStyles.montserratStyle.regular14Black,
                    ),
                    trailing: Text(
                      Constants.videos,
                      style:
                          AppTextStyles.montserratStyle.regular12Black.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoDetailPage(
                                  videoId:
                                      suggestionModel?.topVideos?[index].id ??
                                          0)));
                    },
                  );
                })
            : const SizedBox(),
        ListTile(
          leading: const Icon(
            Icons.search,
            color: AppColors.tiffanyBlue,
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: Constants.allResultFor,
                  style: DefaultTextStyle.of(context).style,
                ),
                TextSpan(
                  text: " ${resultSearchText ?? ''}",
                  style: DefaultTextStyle.of(context).style,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
