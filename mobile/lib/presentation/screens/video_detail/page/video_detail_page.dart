import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_body.dart';

class VideoDetailPage extends StatelessWidget {
  final int videoId;
  final int? targetCommentId;
  final int? targetReplyId;

  const VideoDetailPage(
      {super.key,
      required this.videoId,
      this.targetCommentId,
      this.targetReplyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoDetailBloc>(
      create: (context) => VideoDetailBloc()
        ..add(VideoDetailInitialEvent(
            videoId: videoId,
            targetCommentId: targetCommentId,
            targetReplyId: targetReplyId)),
      child: const VideoDetailBody(),
    );
  }
}
