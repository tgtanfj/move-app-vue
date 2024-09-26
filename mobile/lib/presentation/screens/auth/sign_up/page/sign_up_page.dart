import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:move_app/presentation/screens/auth/sign_up/page/sign_up_body.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(),
        child: const SignUpBody(),
      ),
    );
  }

}
