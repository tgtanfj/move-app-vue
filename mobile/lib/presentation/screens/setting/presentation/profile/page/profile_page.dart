import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/setting/presentation/profile/page/profile_body.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) {
        final bloc = ProfileBloc();
        bloc.add(ProfileInitialEvent());
        return bloc;
      },
      child: const ProfileBody(),
    );
  }
}
