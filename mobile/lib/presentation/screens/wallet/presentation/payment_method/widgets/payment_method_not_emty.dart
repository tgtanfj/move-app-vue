import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/bloc/payment_method_state.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/widgets/remove_card_dialog.dart';

class PaymentMethodNotEmpty extends StatefulWidget {
  const PaymentMethodNotEmpty({super.key});

  @override
  State<PaymentMethodNotEmpty> createState() => _PaymentMethodNotEmptyState();
}

class _PaymentMethodNotEmptyState extends State<PaymentMethodNotEmpty> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
        builder: (context, state) {
      return Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              Constants.yourPaymentMethod,
              style: AppTextStyles.montserratStyle.bold16Black,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightGrey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: const Offset(-3, 3),
                    ),
                    BoxShadow(
                      color: AppColors.lightGrey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: const Offset(3, 3),
                    ),
                  ]),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      Constants.cardholderName,
                      style: AppTextStyles.montserratStyle.regular12Black,
                    ),
                    Expanded(child: Container()),
                    Text(
                      Constants.edit,
                      style: AppTextStyles.montserratStyle.regular14TiffanyBlue,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => RemoveCardDialog(
                            yesCallback: () {
                              context.read<PaymentMethodBloc>().add(
                                  PaymentMethodDetachCardEvent(
                                      state.cardPaymentModel?.id));
                            },
                          ),
                        );
                      },
                      child: Text(
                        Constants.remove,
                        style: AppTextStyles.montserratStyle.regular14BrinkPink,
                      ),
                    ),
                  ]),
                  Text(
                    state.cardPaymentModel?.name ?? Constants.noName,
                    style: AppTextStyles.montserratStyle.regular18Black,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Constants.cardNumber,
                    style: AppTextStyles.montserratStyle.regular12Black,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                            border: Border.all(
                              color: AppColors.chineseSilver,
                              width: 1,
                            )),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: SvgPicture.asset(
                            AppIcons.visa.svgAssetPath,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Constants.anonymousCardNumber,
                            style: AppTextStyles.montserratStyle.regular18Black,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Text(
                            state.cardPaymentModel?.card?.last4 ?? '',
                            style: AppTextStyles.montserratStyle.bold16Black,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
