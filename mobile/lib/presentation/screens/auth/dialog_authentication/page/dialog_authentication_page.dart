import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/auth/dialog_authentication/bloc/dialog_authentication_bloc.dart';

import 'dialog_authentication_body.dart';

class DialogAuthenticationPage extends StatefulWidget {
  const DialogAuthenticationPage({super.key});

  @override
  State<DialogAuthenticationPage> createState() =>
      _DialogAuthenticationPageState();
}

class _DialogAuthenticationPageState extends State<DialogAuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DialogAuthenticationBloc>(
      create: (context) => DialogAuthenticationBloc(),
      child: DialogAuthenticationBody(),
    );
  }
}
