import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/view_faqs_repository.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_bloc.dart';
import 'package:move_app/presentation/screens/view_faqs/page/view_faqs_body.dart';

class ViewFAQsPage extends StatefulWidget {
  const ViewFAQsPage({super.key});

  @override
  State<ViewFAQsPage> createState() => _ViewFAQsPageState();
}

class _ViewFAQsPageState extends State<ViewFAQsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewFaqsBloc>(
      create: (context) => ViewFaqsBloc(ViewFaqsRepository()),
      child: const ViewFAQsBody(),
    );
  }
}
