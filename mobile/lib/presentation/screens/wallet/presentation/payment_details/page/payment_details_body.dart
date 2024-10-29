import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/custom_dropdown_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_state.dart';

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
      if (state.status == PaymentDetailsStatus.processing) {
        EasyLoading.show();
      } else if (state.status == PaymentDetailsStatus.success) {
        EasyLoading.dismiss();
      } else if (state.status == PaymentDetailsStatus.failure) {
        EasyLoading.dismiss();
      }
      if (state.status == PaymentDetailsStatus.added) {
        EasyLoading.dismiss();
        //TODO: add screen
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
                        titleStyle:
                            AppTextStyles.montserratStyle.regular14Black,
                        onChanged: (value) => {
                          BlocProvider.of<PaymentDetailsBloc>(context).add(
                            PaymentDetailsCardHolderNameEvent(
                              cardHolderName: value,
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
                        hintText: state.selectedCountry?.name ?? '',
                        initialValue: state.selectedCountry?.id,
                        items: state.countryList.map((country) {
                          return {'id': country.id, 'name': country.name};
                        }).toList(),
                        onChanged: (countryId) {
                          if (countryId != null) {
                            BlocProvider.of<PaymentDetailsBloc>(context).add(
                              PaymentDetailsCountrySelectEvent(
                                  selectedCountry: state.countryList.firstWhere(
                                (e) => e.id == countryId,
                              )),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomEditText(
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
                              hintText: Constants.formatExpiryDate,
                              title: Constants.expiryDate,
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
                              initialValue: state.cvv,
                              title: Constants.cvv,
                              titleStyle:
                                  AppTextStyles.montserratStyle.regular14Black,
                              onChanged: (value) => {
                                BlocProvider.of<PaymentDetailsBloc>(context)
                                    .add(
                                  PaymentDetailsCvvEvent(
                                    cvv: value,
                                  ),
                                )
                              },
                              isShowMessage: state.isShowCvvMessage ?? false,
                              textStyle: (state.isShowCvvMessage ?? false)
                                  ? AppTextStyles
                                      .montserratStyle.regular14BrinkPink
                                  : AppTextStyles
                                      .montserratStyle.regular14Black,
                              borderColor: AppColors.brinkPink,
                              cursorColor: (state.isShowCvvMessage ?? false)
                                  ? AppColors.brinkPink
                                  : AppColors.tiffanyBlue,
                              preMessage: state.cvvErrorMessage ?? '',
                              suffixLabel: SvgPicture.asset(
                                AppIcons.question.svgAssetPath,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.sonicSilver,
                                  BlendMode.srcIn,
                                ),
                                width: 18,
                                height: 18,
                              ),
                            ),
                          )
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
                          isEnabled: state.isEnableSubmitPaymentMethod ?? false,
                          title: Constants.submit,
                          titleStyle: AppTextStyles.montserratStyle.bold16White,
                          backgroundColor:
                              (state.isEnableSubmitPaymentMethod ?? false)
                                  ? AppColors.tiffanyBlue
                                  : AppColors.spanishGray,
                          borderColor:
                              (state.isEnableSubmitPaymentMethod ?? false)
                                  ? AppColors.tiffanyBlue
                                  : AppColors.spanishGray,
                          onTap: (state.isEnableSubmitPaymentMethod ?? false)
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
                                  // Navigator.pop(context, true);
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
