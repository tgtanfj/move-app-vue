import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/forgot_password_repository.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:move_app/presentation/screens/forgot_password/page/forgot_password/forgot_password_body.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ForgotPasswordRepository forgotPasswordRepository =
      ForgotPasswordRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ForgotPasswordBloc(forgotPasswordRepository),
        child: const ForgotPasswordBody());
  }
}
