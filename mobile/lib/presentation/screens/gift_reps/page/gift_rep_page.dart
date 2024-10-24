import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/gift_reps/bloc/gift_reps_bloc.dart';
import 'package:move_app/presentation/screens/gift_reps/bloc/gift_reps_event.dart';
import 'package:move_app/presentation/screens/gift_reps/page/gift_reps_body.dart';

class GiftRepPage extends StatelessWidget {
  final int? videoId;
  const GiftRepPage({super.key, this.videoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GiftRepsBloc>(
      create: (context) => GiftRepsBloc()..add(GiftRepsInitialEvent(videoId)),
      child: const GiftRepsBody(),
    );
  }
}
