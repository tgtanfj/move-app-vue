import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_bloc.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_event.dart';
import 'package:move_app/presentation/screens/buy_rep/page/buy_rep_body.dart';

class BuyRepPage extends StatelessWidget {
  final RepModel rep;

  const BuyRepPage({
    super.key,
    required this.rep,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BuyRepBloc>(
      create: (context) {
        final bloc = BuyRepBloc();
        bloc.add(BuyRepInitialEvent(rep));
        return bloc;
      },
      child: const BuyRepBody(),
    );
  }
}
