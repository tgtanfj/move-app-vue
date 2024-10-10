import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/custom_dropdown_with_icon.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';

class SortAndFilterBody extends StatefulWidget {
  const SortAndFilterBody({super.key});

  @override
  State<SortAndFilterBody> createState() => _SortAndFilterBodyState();
}

class _SortAndFilterBodyState extends State<SortAndFilterBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Constants.sortFilter,
                  style: AppTextStyles.montserratStyle.bold16Black,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    AppIcons.close.svgAssetPath,
                    width: 24,
                    height: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 23),
            BlocBuilder<SortAndFilterBloc, SortAndFilterState>(
                builder: (context, state) {
              if (state.status == SortAndFilterStatus.loading) {
                EasyLoading.show();
              } else if (state.status == SortAndFilterStatus.loaded) {
                EasyLoading.dismiss();
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 83,
                          child: Text(
                            Constants.level,
                            style: AppTextStyles.montserratStyle.bold14Black,
                          ),
                        ),
                        const SizedBox(
                          width: 29,
                        ),
                        Expanded(
                            child: CustomDropdownWithIcon(
                          onChanged: (value) {
                            BlocProvider.of<SortAndFilterBloc>(context)
                                .add(LevelSelectedEvent(levelId: value));
                          },
                          items: state.levels,
                          initialValue: state.selectedLevel,
                          hintText: 'All Level',
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 83,
                          child: Text(
                            Constants.categorySortFilter,
                            style: AppTextStyles.montserratStyle.bold14Black,
                          ),
                        ),
                        const SizedBox(
                          width: 29,
                        ),
                        Expanded(
                            child: CustomDropdownWithIcon(
                          onChanged: (value) {
                            BlocProvider.of<SortAndFilterBloc>(context)
                                .add(CategorySelectedEvent(categoryId: value));
                          },
                          items: state.categories,
                          initialValue: state.selectedCategory,
                          hintText: 'All Category',
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 83,
                          child: Text(
                            Constants.sortBy,
                            style: AppTextStyles.montserratStyle.bold14Black,
                          ),
                        ),
                        const SizedBox(
                          width: 29,
                        ),
                        Expanded(
                            child: CustomDropdownWithIcon(
                          onChanged: (value) {
                            BlocProvider.of<SortAndFilterBloc>(context)
                                .add(SortBySelectedEvent(sortById: value));
                          },
                          items: state.sortBy,
                          initialValue: state.selectedSortBy,
                          hintText: 'Most recent',
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    CustomButton(
                      title: Constants.confirm,
                      titleStyle: AppTextStyles.montserratStyle.bold16White,
                      backgroundColor: AppColors.tiffanyBlue,
                    )
                  ],
                );
              } else if (state.status == SortAndFilterStatus.error) {
                return const SizedBox();
              }
              return const SizedBox();
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
