import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/presentation/bloc/payment_details_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/presentation/bloc/payment_details_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/presentation/page/payment_details_body.dart';

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = PaymentDetailsBloc();
        bloc.add(const PaymentDetailsInitialEvent());
        return bloc;
      },
      child: const PaymentDetailsBody(),
    );
  }
}
