import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/page/videos_body.dart';

class VideosPage extends StatelessWidget {
  final List<VideoModel>? videos;
  final int channelId;
  final String channelName;
  const VideosPage(
      {super.key, this.videos, this.channelId = 0, required this.channelName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideosBloc>(
      create: (context) {
        final bloc = VideosBloc();
        bloc.add(VideosInitialEvent(channelId: channelId));
        return bloc;
      },
      child: VideosBody(videos: videos, channelName: channelName),
    );
  }
}
