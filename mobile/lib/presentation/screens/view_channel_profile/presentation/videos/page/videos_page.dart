import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/page/videos_body.dart';

class VideosPage extends StatelessWidget {
  final List<VideoModel>? videos;
  const VideosPage({super.key, this.videos});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideosBloc>(
      create: (context) => VideosBloc()..add(VideosInitialEvent()),
      child: VideosBody(videos: videos), 
    );
  }
}

