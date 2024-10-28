import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/payment_repository.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/page/payment_history_body.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentHistoryBloc>(
      create: (context) {
        final paymentHistoryRepository = PaymentRepository();
        final bloc = PaymentHistoryBloc(paymentRepository: paymentHistoryRepository);
        bloc.add(const PaymentHistoryInitialEvent());
        return bloc;
      },
      child: const PaymentHistoryBody(),
    );
  }
}
