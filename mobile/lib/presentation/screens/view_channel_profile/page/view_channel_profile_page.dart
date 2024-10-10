import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/page/view_channel_profile_body.dart';

class ViewChannelProfilePage extends StatefulWidget {
  const ViewChannelProfilePage({super.key});

  @override
  State<ViewChannelProfilePage> createState() => _ViewChannelProfilePageState();
}

class _ViewChannelProfilePageState extends State<ViewChannelProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewChannelProfileBloc>(create: (context) => ViewChannelProfileBloc(), child: const ViewChannelProfileBody());
  }
}