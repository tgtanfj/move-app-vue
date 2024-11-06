import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/wallet_argument_model.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/page/payment_details_body.dart';

class PaymentDetailsPage extends StatefulWidget {
  final WalletArguments? walletArguments;
  const PaymentDetailsPage({super.key, this.walletArguments});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = PaymentDetailsBloc();
        bloc.add(PaymentDetailsInitialEvent(
            walletArguments: widget.walletArguments));
        return bloc;
      },
      child: const PaymentDetailsBody(),
    );
  }
}
