import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_state.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/widgets/payment_method_empty.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/widgets/payment_method_not_emty.dart';

class PaymentMethodBody extends StatefulWidget {
  const PaymentMethodBody({super.key});

  @override
  State<PaymentMethodBody> createState() => _PaymentMethodBodyState();
}

class _PaymentMethodBodyState extends State<PaymentMethodBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<PaymentMethodBloc, PaymentMethodState>(
        listener: (context, state) {
      if (state.status == PaymentMethodStatus.processing) {
        EasyLoading.show();
      } else {
        EasyLoading.dismiss();
      }
      if (state.status == PaymentMethodStatus.success) {
        EasyLoading.dismiss();
      } else if (state.status == PaymentMethodStatus.failure) {
        EasyLoading.dismiss();
      }
      if (state.status == PaymentMethodStatus.removed) {
        EasyLoading.dismiss();
        Navigator.pushNamed(context, AppRoutes.routeWallet);
      }
    }, builder: (context, state) {
      return state.cardPaymentModel == null
          ? const PaymentMethodEmpty()
          : const PaymentMethodNotEmpty();
    });
  }
}
