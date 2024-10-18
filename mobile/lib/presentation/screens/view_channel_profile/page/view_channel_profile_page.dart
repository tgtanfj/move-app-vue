import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/page/view_channel_profile_body.dart';

class ViewChannelProfilePage extends StatelessWidget {
  // final List<VideoModel>? videos;
  const ViewChannelProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewChannelProfileBloc>(
      create: (context) {
        final bloc = ViewChannelProfileBloc();
        bloc.add(ViewChannelProfileInitialEvent());
        return bloc;
      },
      child: const ViewChannelProfileBody(),
    );
  }
}
