import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_bloc.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_event.dart';
import 'package:move_app/presentation/screens/auth/otp/page/otp_verification_body.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpVerificationBloc>(
      create: (context) =>
          OtpVerificationBloc()..add(OtpVerificationInitialEvent(widget.email)),
      child: const OtpVerificationBody(),
    );
  }
}
