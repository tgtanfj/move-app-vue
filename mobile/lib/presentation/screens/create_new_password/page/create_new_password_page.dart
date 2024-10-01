import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_bloc.dart';
import 'package:move_app/presentation/screens/create_new_password/page/create_new_password_body.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({super.key});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CreatePasswordBloc(),
        child: const Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: CreateNewPasswordBody()));
  }
}
