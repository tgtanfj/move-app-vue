import 'package:flutter/widgets.dart';
import 'package:move_app/data/models/wallet_argument_model.dart';
import 'package:move_app/presentation/screens/wallet/page/wallet_body.dart';

class WalletPage extends StatelessWidget {
  final WalletArguments? walletArguments;

  const WalletPage({super.key, this.walletArguments});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as WalletArguments? ?? walletArguments;
    return WalletBody(arguments: args);
  }
}
