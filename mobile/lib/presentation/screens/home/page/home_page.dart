import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/home/bloc/home_bloc.dart';
import 'package:move_app/presentation/screens/home/bloc/home_event.dart';
import 'package:move_app/presentation/screens/home/page/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoadingPage = ModalRoute.of(context)?.settings.arguments as bool? ?? true;
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc()..add(HomeInitialEvent(isLoadingPage: isLoadingPage)),
      child: const HomeBody(),
    );
  }
}
