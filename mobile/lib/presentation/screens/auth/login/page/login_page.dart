import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/auth_repository.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import 'login_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) {
        final authRepository = AuthRepository();
        final bloc = LoginBloc(authenticationRepository: authRepository);
        bloc.add(LoginInitialEvent());
        return bloc;
      },
      child: const LoginBody(),
    );
  }
}
