import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/suggestion_model.dart';

import '../../../../config/theme/app_icons.dart';
import '../../../../config/theme/app_images.dart';
import '../../../components/avatar.dart';

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
            ? ListTile(
                leading: Image.network(
                  suggestionModel?.topCategory?.image ?? "",
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
                title: Text(suggestionModel?.topCategory?.title ?? ""),
                trailing: Text(
                  Constants.categories,
                  style: AppTextStyles.montserratStyle.regular12Black.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onTap: () {},
              )
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
                    title: Row(
                      children: [
                        Text(
                            suggestionModel?.topInstructors?[index].name ?? ""),
                        const Text(" "),
                        (suggestionModel?.topInstructors?[index].isBlueBadge ??
                                false)
                            ? SvgPicture.asset(AppIcons.blueStick.svgAssetPath)
                            : const SizedBox(),
                        const Text(" "),
                        (suggestionModel?.topInstructors?[index].isPinkBadge ??
                                false)
                            ? SvgPicture.asset(AppIcons.starFlower.svgAssetPath)
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
                    onTap: () {},
                  );
                })
            : const SizedBox(),
        (suggestionModel?.topVideos != null)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: suggestionModel?.topVideos?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestionModel?.topVideos?[index].title ?? ""),
                    trailing: Text(
                      Constants.videos,
                      style:
                          AppTextStyles.montserratStyle.regular12Black.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {},
                  );
                })
            : const SizedBox(),
        if (suggestionModel?.topCategory != null ||
            suggestionModel?.topInstructors != null ||
            suggestionModel?.topVideos != null)
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
            )
            ,
          )
      ],
    );
  }
}
