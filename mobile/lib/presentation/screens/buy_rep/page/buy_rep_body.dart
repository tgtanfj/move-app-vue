import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_logout_button.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_bloc.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_event.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_state.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/order_failed_dialog.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/order_success_dialog.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/processing_payment_dialog.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/with_saved_payment.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/without_saved_payment.dart';

class BuyRepBody extends StatefulWidget {
  const BuyRepBody({super.key});

  @override
  State<BuyRepBody> createState() => _BuyRepBodyState();
}

class _BuyRepBodyState extends State<BuyRepBody> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<BuyRepBloc, BuyRepState>(
      listener: (context, state) {
        if (state.status == BuyRepStatus.processing) {
          EasyLoading.show();
        } else {
          EasyLoading.dismiss();
        }
        if (state.status == BuyRepStatus.orderProcessing) {
          showDialog(
              context: context,
              builder: (BuildContext build) {
                return const ProcessingPaymentDialog();
              });
        }
        if (state.status == BuyRepStatus.orderSuccess) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (BuildContext build) {
                return OrderSuccessDialog(rep: state.rep);
              }).then((onValue) {
            if (onValue) {
              if (!context.mounted) return;
              Navigator.of(context).pop();
            }
          });
        }
        if (state.status == BuyRepStatus.orderFailed) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (BuildContext build) {
                return OrderFailedDialog(rep: state.rep);
              }).then((onValue) {
            if (onValue) {
              if (!context.mounted) return;
              Navigator.of(context).pop();
            }
          });
        }
      },
      child: BlocBuilder<BuyRepBloc, BuyRepState>(builder: (context, state) {
        final screenHeight = MediaQuery.of(context).size.height;
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: state.status == BuyRepStatus.orderProcessing ||
                  state.status == BuyRepStatus.orderFailed ||
                  state.status == BuyRepStatus.orderSuccess
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          height: state.cardPaymentMethod != null
                              ? screenHeight
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(Constants.completePurchase,
                                      style: AppTextStyles
                                          .montserratStyle.bold24black),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SvgPicture.asset(
                                      AppIcons.close.svgAssetPath,
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                Constants.orderSummary,
                                style: AppTextStyles
                                    .montserratStyle.bold16DarkSilver,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${state.rep?.numberOfREPs} ${Constants.rep}',
                                      style: AppTextStyles
                                          .montserratStyle.bold16black),
                                  Text('${Constants.us}${state.rep?.price}',
                                      style: AppTextStyles
                                          .montserratStyle.regular16Black)
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                  '${Constants.oneTimeChargeOn} ${DateFormat('d MMM y').format(DateTime.now())}',
                                  style: AppTextStyles
                                      .montserratStyle.regular14sonicSilver),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(Constants.total,
                                      style: AppTextStyles
                                          .montserratStyle.regular16Black),
                                  Text('${Constants.us}${state.rep?.price}',
                                      style: AppTextStyles
                                          .montserratStyle.bold16black)
                                ],
                              ),
                              const SizedBox(height: 32),
                              Text(
                                Constants.paymentDetails,
                                style: AppTextStyles
                                    .montserratStyle.bold16DarkSilver,
                              ),
                              const SizedBox(height: 12),
                              state.cardPaymentMethod == null
                                  ? WithoutSavedPayment(
                                      countries: state.countries,
                                      onChangeCardName: (value) {
                                        context.read<BuyRepBloc>().add(
                                            BuyRepCardNameEvent(
                                                cardName: value));
                                      },
                                      onChangedCountry: (value) {
                                        context.read<BuyRepBloc>().add(
                                            BuyRepCountryEvent(
                                                countryCode: state.countries
                                                    ?.firstWhere(
                                                        (e) => e.id == value)
                                                    .countryCode));
                                      },
                                      onChangeCardNumber: (value) {
                                        context.read<BuyRepBloc>().add(
                                            BuyRepCardNumberEvent(
                                                cardNumber: value));
                                      },
                                      onChangeExpiryDate: (value) {
                                        context.read<BuyRepBloc>().add(
                                            BuyRepExpiryDateEvent(
                                                expiryDate: value));
                                      },
                                      onChangeCvv: (value) {
                                        context
                                            .read<BuyRepBloc>()
                                            .add(BuyRepCvvEvent(cvv: value));
                                      },
                                      onCardNameFocusLost: (value) {
                                        context.read<BuyRepBloc>().add(
                                            BuyRepCardNameEvent(
                                                cardName: value.trim()));
                                      },
                                      isShowCardNameMessage:
                                          state.isShowCardNameMessage,
                                      isShowCardNumberMessage:
                                          state.isShowCardNumberMessage,
                                      isShowExpiryDateMessage:
                                          state.isShowExpiryDateMessage,
                                      isShowCvvMessage: state.isShowCvvMessage,
                                      messageInputCardName:
                                          state.messageInputCardName,
                                      messageInputCardNumber:
                                          state.messageInputCardNumber,
                                      messageInputExpiryDate:
                                          state.messageInputExpiryDate,
                                      messageInputCvv: state.messageInputCvv,
                                      initialCountry: state.countries
                                          ?.firstWhere(
                                              (e) => e.countryCode == "VN")
                                          .id,
                                      cardType: state.cardType,
                                    )
                                  : WithSavedPayment(
                                      card: state.cardPaymentMethod?.card,
                                      rep: state.rep),
                              const SizedBox(height: 24),
                              Text.rich(
                                TextSpan(
                                  text: Constants.bySubmittingPayment,
                                  style: AppTextStyles
                                      .montserratStyle.regular14sonicSilver,
                                  children: [
                                    TextSpan(
                                        text: Constants.endUserLicenseAgreement,
                                        style: AppTextStyles.montserratStyle
                                            .regular14TiffanyBlue),
                                    const TextSpan(text: ', '),
                                    TextSpan(
                                        text: Constants.privacyPolicy,
                                        style: AppTextStyles.montserratStyle
                                            .regular14TiffanyBlue),
                                    const TextSpan(text: Constants.and),
                                    TextSpan(
                                        text: Constants.refundPolicy,
                                        style: AppTextStyles.montserratStyle
                                            .regular14TiffanyBlue),
                                    const TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                      state.cardPaymentMethod == null ? 60 : 0),
                              state.cardPaymentMethod == null
                                  ? Row(children: [
                                      InkWell(
                                          splashFactory: NoSplash.splashFactory,
                                          onTap: () {
                                            context
                                                .read<BuyRepBloc>()
                                                .add(BuyRepSavePaymentEvent());
                                          },
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.tiffanyBlue,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: state.isSavePayment
                                                ? const Icon(
                                                    Icons.check,
                                                    color:
                                                        AppColors.tiffanyBlue,
                                                  )
                                                : const SizedBox(),
                                          )),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          Constants.saveMyPayment,
                                          style: AppTextStyles.montserratStyle
                                              .regular14sonicSilver,
                                        ),
                                      ),
                                    ])
                                  : const SizedBox(),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: Constants.total,
                                          style: AppTextStyles
                                              .montserratStyle.regular16Black,
                                          children: [
                                        TextSpan(
                                            text:
                                                ' ${Constants.us}${state.rep?.price}',
                                            style: AppTextStyles
                                                .montserratStyle.bold16black)
                                      ])),
                                  const SizedBox(width: 30),
                                  CustomLogoutButton(
                                    isEnabled: state.cardPaymentMethod != null
                                        ? true
                                        : state.isEnablePayNow,
                                    borderColor:
                                        (state.cardPaymentMethod != null
                                                ? true
                                                : state.isEnablePayNow)
                                            ? AppColors.tiffanyBlue
                                            : AppColors.spanishGray,
                                    onTap: () {
                                      context
                                          .read<BuyRepBloc>()
                                          .add(BuyRepPayNowEvent());
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    backgroundColor:
                                        (state.cardPaymentMethod != null
                                                ? true
                                                : state.isEnablePayNow)
                                            ? AppColors.tiffanyBlue
                                            : AppColors.spanishGray,
                                    title: Constants.payNow,
                                    titleStyle: AppTextStyles
                                        .montserratStyle.bold16White,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
