import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_bloc.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_event.dart';
import 'package:move_app/presentation/screens/menu/page/menu_body.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isStayAtCurrentPage =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    return BlocProvider<MenuBloc>(
      create: (context) => MenuBloc()
        ..add(MenuInitialEvent(isStateAtCurrentPage: isStayAtCurrentPage)),
      child: const MenuBody(),
    );
  }
}
