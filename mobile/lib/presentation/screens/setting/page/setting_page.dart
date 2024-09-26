import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/setting/bloc/setting_bloc.dart';
import 'package:move_app/presentation/screens/setting/bloc/setting_event.dart';
import 'package:move_app/presentation/screens/setting/page/setting_body.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingBloc>(
      create: (context) {
        final bloc = SettingBloc();
        bloc.add(SettingInitialEvent());
        return bloc;
      },
      child: const SettingBody(),
    );
  }
}
