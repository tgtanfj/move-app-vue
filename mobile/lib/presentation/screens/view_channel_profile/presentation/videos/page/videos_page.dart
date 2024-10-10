import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/page/videos_body.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideosBloc>(
      create: (context) => VideosBloc(),
      child: const VideosBody(),
    );
  }
}
