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
import 'package:tuple/tuple.dart';

class SortAndFilterBody extends StatefulWidget {
  final String? initialLevel;
  final int? initialCategoryId;
  final String? initialSortBy;
  const SortAndFilterBody(
      {super.key,
      this.initialLevel,
      this.initialCategoryId,
      this.initialSortBy});

  @override
  State<SortAndFilterBody> createState() => _SortAndFilterBodyState();
}

class _SortAndFilterBodyState extends State<SortAndFilterBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SortAndFilterBloc, SortAndFilterState>(
      listener: (context, state) {
        if (state.status == SortAndFilterStatus.processing) {
          EasyLoading.show();
        } else if (state.status == SortAndFilterStatus.success) {
          EasyLoading.dismiss();
        } else if (state.status == SortAndFilterStatus.failure) {
          EasyLoading.dismiss();
        } else if (state.status == SortAndFilterStatus.pop) {
          EasyLoading.dismiss();
          Navigator.of(context).pop(Tuple3(
            state.selectedLevel,
            state.selectedCategory,
            state.selectedSortBy,
          ));
        }
      },
      builder: (context, state) {
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
                Row(
                  children: [
                    SizedBox(
                      width: 83,
                      child: Text(
                        Constants.level,
                        style: AppTextStyles.montserratStyle.bold14Black,
                      ),
                    ),
                    const SizedBox(width: 29),
                    Expanded(
                      child: CustomDropdownWithIcon(
                        onChanged: (value) {
                          if (value != null) {
                            BlocProvider.of<SortAndFilterBloc>(context).add(
                                LevelSelectedEvent(
                                    level: WorkoutLevelType.values[value]));
                          }
                        },
                        items: WorkoutLevelType.values
                            .map((e) => (e.index, e.title))
                            .toList(),
                        initialValue: state.selectedLevel.index,
                        hintText: state.selectedLevel.title,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: 83,
                      child: Text(
                        Constants.categorySortFilter,
                        style: AppTextStyles.montserratStyle.bold14Black,
                      ),
                    ),
                    const SizedBox(width: 29),
                    Expanded(
                      child: CustomDropdownWithIcon(
                        onChanged: (value) {
                          if (value != null) {
                            BlocProvider.of<SortAndFilterBloc>(context).add(
                              CategorySelectedEvent(
                                selectedCategory: state.categories.firstWhere(
                                    (category) => category.id == value),
                              ),
                            );
                          }
                        },
                        items: state.categories.map((category) {
                          return (category.id, category.title);
                        }).toList(),
                        initialValue: state.selectedCategory?.id,
                        hintText: state.selectedCategory?.title,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: 83,
                      child: Text(
                        Constants.sortBy,
                        style: AppTextStyles.montserratStyle.bold14Black,
                      ),
                    ),
                    const SizedBox(width: 29),
                    Expanded(
                      child: CustomDropdownWithIcon(
                        onChanged: (value) {
                          if (value != null) {
                            BlocProvider.of<SortAndFilterBloc>(context).add(
                                SortBySelectedEvent(
                                    sortBy: SortAndFilterType.values[value]));
                          }
                        },
                        items: SortAndFilterType.values
                            .map((e) => (e.index, e.title))
                            .toList(),
                        initialValue: state.selectedSortBy.index,
                        hintText: state.selectedSortBy.title,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                CustomButton(
                  title: Constants.confirm,
                  titleStyle: AppTextStyles.montserratStyle.bold16White,
                  backgroundColor: AppColors.tiffanyBlue,
                  onTap: () {
                    BlocProvider.of<SortAndFilterBloc>(context)
                        .add(SortAndFilterConfirmedEvent());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
