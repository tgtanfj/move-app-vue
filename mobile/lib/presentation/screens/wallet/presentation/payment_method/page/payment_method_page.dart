import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/page/payment_method_body.dart';

class PaymentMethodPage extends StatefulWidget {
  final RepModel? rep;
  const PaymentMethodPage({super.key, this.rep});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentMethodBloc>(
      create: (context) {
        final bloc = PaymentMethodBloc();
        bloc.add(PaymentMethodInitialEvent(widget.rep));
        return bloc;
      },
      child: const PaymentMethodBody(),
    );
  }
}
