import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_bloc.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_event.dart';
import 'package:move_app/presentation/screens/buy_rep/page/buy_rep_body.dart';

class BuyRepPage extends StatelessWidget {
  const BuyRepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BuyRepBloc>(
      create: (context) {
        final bloc = BuyRepBloc();
        bloc.add(BuyRepInitialEvent());
        return bloc;
      },
      child: const BuyRepBody(),
    );
  }
}
