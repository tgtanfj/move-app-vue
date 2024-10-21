import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/page/sort_and_filter_body.dart';

class SortAndFilterPage extends StatelessWidget {
  final WorkoutLevelType? selectedLevel;
  final CategoryModel? selectedCategory;
  final SortAndFilterType? selectedSortBy;
  final int? channelId;
  const SortAndFilterPage({
    super.key,
    required this.selectedLevel,
    required this.selectedCategory,
    required this.selectedSortBy,
    required this.channelId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SortAndFilterBloc()
        ..add(SortAndFilterInitialEvent(
          selectedLevel: selectedLevel,
          selectedCategory: selectedCategory,
          selectedSortBy: selectedSortBy,
          channelId: channelId,
        )),
      child: SortAndFilterBody(
        initialLevel: selectedLevel?.value,
        initialCategoryId: selectedCategory?.id,
        initialSortBy: selectedSortBy?.value,
      ),
    );
  }
}
