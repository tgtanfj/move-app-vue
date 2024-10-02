import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/forgot_password_repository.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_bloc.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_event.dart';
import 'package:move_app/presentation/screens/create_new_password/page/create_new_password_body.dart';

class CreateNewPasswordPage extends StatefulWidget {
  final String? token;
  const CreateNewPasswordPage({super.key, this.token});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final ForgotPasswordRepository forgotPasswordRepository =
      ForgotPasswordRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CreatePasswordBloc(forgotPasswordRepository)
          ..add(CreateNewPasswordInitialEvent(token: widget.token ?? '')),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: CreateNewPasswordBody(
            token: widget.token,
            forgotPasswordRepository: forgotPasswordRepository,
          ),
        ));
  }
}
