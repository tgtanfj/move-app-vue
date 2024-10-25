import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/videos_category/bloc/videos_category_bloc.dart';
import 'package:move_app/presentation/screens/videos_category/bloc/videos_category_event.dart';
import 'package:move_app/presentation/screens/videos_category/page/videos_category_body.dart';

class VideosCategoryPage extends StatelessWidget {
  final int categoryId;
  const VideosCategoryPage({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideosCategoryBloc>(
      create: (context) =>
          VideosCategoryBloc()..add(VideosCategoryInitialEvent(categoryId)),
      child: const VideosCategoryBody(),
    );
  }
}
