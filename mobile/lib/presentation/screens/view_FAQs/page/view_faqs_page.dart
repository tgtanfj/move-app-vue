import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_bloc.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_event.dart';
import 'package:move_app/presentation/screens/view_faqs/page/view_faqs_body.dart';

class ViewFAQsPage extends StatelessWidget {
  const ViewFAQsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewFaqsBloc>(
      create: (context) => ViewFaqsBloc()..add(FetchFaqsEvent()),
      child: const ViewFAQsBody(),
    );
  }
}
