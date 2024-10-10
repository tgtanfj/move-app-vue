import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/page/sort_and_filter_body.dart';

class SortAndFilterPage extends StatelessWidget {
  const SortAndFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SortAndFilterBloc()..add(FetchSortFilterDataEvent()),
      child: const SortAndFilterBody(),
    );
  }
}
