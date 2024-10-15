import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_body.dart';

class VideoDetailPage extends StatelessWidget {
  final int videoId;
  const VideoDetailPage({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoDetailBloc>(
      create: (context) => VideoDetailBloc()..add(VideoDetailInitialEvent()),
      child: const VideoDetailBody(),
    );
  }
}
