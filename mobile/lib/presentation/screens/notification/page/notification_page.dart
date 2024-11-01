import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_bloc.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_event.dart';
import 'package:move_app/presentation/screens/notification/page/notification_body.dart';

import '../../../../data/data_sources/remote/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) {
        final notificationService = NotificationService();
        final bloc = NotificationBloc(notificationService);
        bloc.add(NotificationInitialEvent());
        return bloc;
      },
      child: const NotificationBody(),
    );
  }
}

