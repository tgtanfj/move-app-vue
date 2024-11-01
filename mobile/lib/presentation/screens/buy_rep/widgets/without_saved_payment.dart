import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/country_model.dart';
import 'package:move_app/presentation/components/custom_dropdown_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/utils/card_date_formatter.dart';

class WithoutSavedPayment extends StatelessWidget {
  final Function(String)? onChangeCardName;
  final Function(String)? onChangeCardNumber;
  final Function(String)? onChangeExpiryDate;
  final Function(String)? onChangeCvv;
  final List<CountryModel>? countries;
  final Function(int)? onChangedCountry;
  final Function(String)? onCardNameFocusLost;
  final String messageInputCardName;
  final String messageInputCardNumber;
  final String messageInputExpiryDate;
  final String messageInputCvv;
  final bool isShowCardNameMessage;
  final bool isShowCardNumberMessage;
  final bool isShowExpiryDateMessage;
  final bool isShowCvvMessage;
  final int? initialCountry;

  const WithoutSavedPayment({
    super.key,
    this.onChangeCardName,
    this.onChangeCardNumber,
    this.onChangeExpiryDate,
    this.onChangeCvv,
    this.countries,
    this.onChangedCountry,
    this.onCardNameFocusLost,
    this.messageInputCardName = '',
    this.messageInputCardNumber = '',
    this.messageInputExpiryDate = '',
    this.messageInputCvv = '',
    this.isShowCardNameMessage = false,
    this.isShowCardNumberMessage = false,
    this.isShowExpiryDateMessage = false,
    this.isShowCvvMessage = false,
    this.initialCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Constants.cardholderName,
          style: AppTextStyles.montserratStyle.regular14Black,
        ),
        CustomEditText(
          onChanged: onChangeCardName,
          textInputType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")),
            LengthLimitingTextInputFormatter(50),
          ],
          onLostFocus: onCardNameFocusLost,
          isShowMessage: isShowCardNameMessage,
          textStyle: isShowCardNameMessage
              ? AppTextStyles.montserratStyle.regular14BrinkPink
              : AppTextStyles.montserratStyle.regular14Black,
          borderColor: AppColors.brinkPink,
          cursorColor: isShowCardNameMessage
              ? AppColors.brinkPink
              : AppColors.tiffanyBlue,
          preMessage: messageInputCardName,
          widthMessage: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 12),
        Text(
          Constants.country,
          style: AppTextStyles.montserratStyle.regular14Black,
        ),
        const SizedBox(height: 4),
        CustomDropdownButton(
          initialValue: initialCountry,
          items: countries?.map((country) {
            return {'id': country.id, 'name': country.name};
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChangedCountry?.call(value);
            }
          },
        ),
        const SizedBox(height: 12),
        Text(
          Constants.cardNumber,
          style: AppTextStyles.montserratStyle.regular14Black,
        ),
        CustomEditText(
          onChanged: onChangeCardNumber,
          isShowMessage: isShowCardNumberMessage,
          textInputType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          textStyle: isShowCardNumberMessage
              ? AppTextStyles.montserratStyle.regular14BrinkPink
              : AppTextStyles.montserratStyle.regular14Black,
          borderColor: AppColors.brinkPink,
          cursorColor: isShowCardNumberMessage
              ? AppColors.brinkPink
              : AppColors.tiffanyBlue,
          preMessage: messageInputCardNumber,
          widthMessage: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 12),
        FractionallySizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Constants.expiryDate,
                      style: AppTextStyles.montserratStyle.regular14Black),
                  CustomEditText(
                    hintText: Constants.mmyy,
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                      CardDateFormatter(),
                    ],
                    onChanged: onChangeExpiryDate,
                    isShowMessage: isShowExpiryDateMessage,
                    textStyle: isShowExpiryDateMessage
                        ? AppTextStyles.montserratStyle.regular14BrinkPink
                        : AppTextStyles.montserratStyle.regular14Black,
                    borderColor: AppColors.brinkPink,
                    cursorColor: isShowExpiryDateMessage
                        ? AppColors.brinkPink
                        : AppColors.tiffanyBlue,
                    preMessage: messageInputExpiryDate,
                  ),
                ],
              )),
              const SizedBox(width: 8),
              Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(
                      children: [
                        Text(Constants.cvv2,
                            style:
                                AppTextStyles.montserratStyle.regular14Black),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return cvv2Explain();
                              },
                            );
                          },
                          child: SvgPicture.asset(
                              AppIcons.question.svgAssetPath,
                              width: 18,
                              height: 18),
                        )
                      ],
                    ),
                    CustomEditText(
                        textInputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: onChangeCvv,
                        isShowMessage: isShowCvvMessage,
                        textStyle: isShowCvvMessage
                            ? AppTextStyles.montserratStyle.regular14BrinkPink
                            : AppTextStyles.montserratStyle.regular14Black,
                        borderColor: AppColors.brinkPink,
                        cursorColor: isShowCvvMessage
                            ? AppColors.brinkPink
                            : AppColors.tiffanyBlue,
                        preMessage: messageInputCvv),
                  ])),
            ],
          ),
        ),
      ],
    );
  }

  Widget masterCard() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
          height: 25,
          width: 34,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.chineseSilver,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SvgPicture.asset(
            AppIcons.masterCard.svgAssetPath,
          )),
    );
  }

  Widget cvv2Explain() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          Constants.cvv2Explain,
          style: AppTextStyles.montserratStyle.regular14Black,
        ),
      ),
    );
  }
}
