import 'package:flutter/widgets.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/page/payment_method_body.dart';

class PaymentMethodPage extends StatefulWidget {
  final bool? showCardHolder;
  const PaymentMethodPage({super.key, this.showCardHolder});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return PaymentMethodBody(showCardHolder: widget.showCardHolder);
  }
}
