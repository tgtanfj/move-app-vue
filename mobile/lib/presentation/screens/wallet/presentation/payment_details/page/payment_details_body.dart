import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/data/models/wallet_argument_model.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/custom_dropdown_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/buy_rep/page/buy_rep_page.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/card_item.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_state.dart';
import 'package:move_app/utils/card_date_formatter.dart';

class PaymentDetailsBody extends StatefulWidget {
  const PaymentDetailsBody({super.key});

  @override
  State<PaymentDetailsBody> createState() => _PaymentDetailsBodyState();
}

class _PaymentDetailsBodyState extends State<PaymentDetailsBody> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentDetailsBloc, PaymentDetailsState>(
        listener: (context, state) {
      state.status == PaymentDetailsStatus.processing
          ? EasyLoading.show()
          : EasyLoading.dismiss();

      if (state.status == PaymentDetailsStatus.added &&
          state.walletArguments?.rep?.id != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
        showDialog(
            context: context,
            builder: (BuildContext build) {
              return BuyRepPage(rep: state.walletArguments!.rep!);
            });
        return;
      }
      if (state.status == PaymentDetailsStatus.added) {
        EasyLoading.dismiss();
        Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.routeWallet,
            arguments: WalletArguments(rep: RepModel(), isTrue: true),
            (route) => false);
      }
    }, child: BlocBuilder<PaymentDetailsBloc, PaymentDetailsState>(
            builder: (context, state) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: const AppBarWidget(),
          backgroundColor: AppColors.white,
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Constants.paymentDetails,
                            style: AppTextStyles.montserratStyle.bold24black,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: SvgPicture.asset(
                              AppIcons.close.svgAssetPath,
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomEditText(
                        initialValue: state.cardHolderName,
                        title: Constants.cardholderName,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z\s]")),
                          LengthLimitingTextInputFormatter(50),
                        ],
                        titleStyle:
                            AppTextStyles.montserratStyle.regular14Black,
                        onChanged: (value) => {
                          BlocProvider.of<PaymentDetailsBloc>(context).add(
                            PaymentDetailsCardHolderNameEvent(
                              cardHolderName: value,
                            ),
                          )
                        },
                        onLostFocus: (value) => {
                          BlocProvider.of<PaymentDetailsBloc>(context).add(
                            PaymentDetailsCardHolderNameEvent(
                              cardHolderName: value.trim(),
                            ),
                          )
                        },
                        isShowMessage:
                            state.isShowCardHolderNameMessage ?? false,
                        textStyle: (state.isShowCardHolderNameMessage ?? false)
                            ? AppTextStyles.montserratStyle.regular14BrinkPink
                            : AppTextStyles.montserratStyle.regular14Black,
                        borderColor: AppColors.brinkPink,
                        cursorColor:
                            (state.isShowCardHolderNameMessage ?? false)
                                ? AppColors.brinkPink
                                : AppColors.tiffanyBlue,
                        widthMessage: MediaQuery.of(context).size.width,
                        preMessage: state.cardHolderNameErrorMessage ?? '',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      _createTitle(title: Constants.country),
                      CustomDropdownButton(
                        hintText: state.selectedCountry?.name ??
                            Constants.pleaseSelectCountry,
                        initialValue: (state.selectedCountry?.id != null)
                            ? state.selectedCountry?.id
                            : null,
                        items: state.countryList
                            .map((country) => country.toJson())
                            .toList(),
                        onChanged: (countryId) {
                          if (countryId != null) {
                            BlocProvider.of<PaymentDetailsBloc>(context).add(
                              PaymentDetailsCountrySelectEvent(
                                countryId: countryId,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomEditText(
                        textInputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        initialValue: state.cardNumber,
                        title: Constants.cardNumber,
                        titleStyle:
                            AppTextStyles.montserratStyle.regular14Black,
                        onChanged: (value) => {
                          BlocProvider.of<PaymentDetailsBloc>(context).add(
                            PaymentDetailsCardNumberEvent(
                              cardNumber: value,
                            ),
                          )
                        },
                        isShowMessage: state.isShowCardNumberMessage ?? false,
                        textStyle: (state.isShowCardNumberMessage ?? false)
                            ? AppTextStyles.montserratStyle.regular14BrinkPink
                            : AppTextStyles.montserratStyle.regular14Black,
                        borderColor: AppColors.brinkPink,
                        cursorColor: (state.isShowCardNumberMessage ?? false)
                            ? AppColors.brinkPink
                            : AppColors.tiffanyBlue,
                        widthMessage: MediaQuery.of(context).size.width,
                        preMessage: state.cardNumberErrorMessage ?? '',
                        suffix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CardItem(cardType: state.cardType),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomEditText(
                              initialValue: state.expiryDate,
                              hintText: Constants.mmyy,
                              title: Constants.expiryDate,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                                CardDateFormatter(),
                              ],
                              titleStyle:
                                  AppTextStyles.montserratStyle.regular14Black,
                              onChanged: (value) => {
                                BlocProvider.of<PaymentDetailsBloc>(context)
                                    .add(
                                  PaymentDetailsExpiryDateEvent(
                                    expiryDate: value,
                                  ),
                                )
                              },
                              isShowMessage:
                                  state.isShowExpiryDateMessage ?? false,
                              textStyle:
                                  (state.isShowExpiryDateMessage ?? false)
                                      ? AppTextStyles
                                          .montserratStyle.regular14BrinkPink
                                      : AppTextStyles
                                          .montserratStyle.regular14Black,
                              borderColor: AppColors.brinkPink,
                              cursorColor:
                                  (state.isShowExpiryDateMessage ?? false)
                                      ? AppColors.brinkPink
                                      : AppColors.tiffanyBlue,
                              preMessage: state.expiryDateErrorMessage ?? '',
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: CustomEditText(
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            initialValue: state.cvv,
                            title: Constants.cvv,
                            titleStyle:
                                AppTextStyles.montserratStyle.regular14Black,
                            onChanged: (value) => {
                              BlocProvider.of<PaymentDetailsBloc>(context).add(
                                PaymentDetailsCvvEvent(
                                  cvv: value,
                                ),
                              )
                            },
                            isShowMessage: state.isShowCvvMessage ?? false,
                            textStyle: (state.isShowCvvMessage ?? false)
                                ? AppTextStyles
                                    .montserratStyle.regular14BrinkPink
                                : AppTextStyles.montserratStyle.regular14Black,
                            borderColor: AppColors.brinkPink,
                            cursorColor: (state.isShowCvvMessage ?? false)
                                ? AppColors.brinkPink
                                : AppColors.tiffanyBlue,
                            preMessage: state.cvvErrorMessage ?? '',
                            suffixLabel: Tooltip(
                              triggerMode: TooltipTriggerMode.tap,
                              height: 50,
                              message: Constants.guideLineCVV,
                              textStyle:
                                  AppTextStyles.montserratStyle.regular14Black,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.spanishGray,
                                  width: 1,
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              showDuration: const Duration(seconds: 2),
                              verticalOffset: 15,
                              textAlign: TextAlign.center,
                              preferBelow: false,
                              child: SvgPicture.asset(
                                AppIcons.question.svgAssetPath,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.sonicSilver,
                                  BlendMode.srcIn,
                                ),
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      RichText(
                        text: TextSpan(
                          text: Constants.bySubmittingPayment,
                          style: AppTextStyles
                              .montserratStyle.regular14sonicSilver,
                          children: [
                            TextSpan(
                                text: Constants.endUserLicense,
                                style: AppTextStyles
                                    .montserratStyle.regular14TiffanyBlue),
                            TextSpan(
                              text: Constants.and,
                              style: AppTextStyles
                                  .montserratStyle.regular14sonicSilver,
                            ),
                            TextSpan(
                                text: Constants.refunPolicy,
                                style: AppTextStyles
                                    .montserratStyle.regular14TiffanyBlue),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                          isEnabled: state.isEnableSubmitPaymentMethod,
                          title: Constants.submit,
                          titleStyle: AppTextStyles.montserratStyle.bold16White,
                          backgroundColor: (state.isEnableSubmitPaymentMethod)
                              ? AppColors.tiffanyBlue
                              : AppColors.spanishGray,
                          borderColor: (state.isEnableSubmitPaymentMethod)
                              ? AppColors.tiffanyBlue
                              : AppColors.spanishGray,
                          onTap: (state.isEnableSubmitPaymentMethod)
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<PaymentDetailsBloc>()
                                      .add(PaymentDetailsSubmitEvent(
                                        paymentMethodId:
                                            state.paymentMethodId ?? '',
                                        cardHolderName:
                                            state.cardHolderName ?? '',
                                        cardNumber: state.cardNumber ?? '',
                                        expiryDate: state.expiryDate ?? '',
                                        cvv: state.cvv ?? '',
                                        country:
                                            state.selectedCountry?.name ?? '',
                                      ));
                                }
                              : null)
                    ]),
              )),
        ),
      );
    }));
  }

  Widget _createTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: AppTextStyles.montserratStyle.regular14Black,
      ),
    );
  }
}
