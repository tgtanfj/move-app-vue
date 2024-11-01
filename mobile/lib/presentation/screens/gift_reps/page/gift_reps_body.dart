import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/buy_rep_dialog.dart';
import 'package:move_app/presentation/screens/gift_reps/bloc/gift_reps_bloc.dart';
import 'package:move_app/presentation/screens/gift_reps/bloc/gift_reps_event.dart';
import 'package:move_app/presentation/screens/gift_reps/bloc/gift_reps_state.dart';
import 'package:move_app/presentation/screens/gift_reps/widgets/gift_reps_success_dialog.dart';

class GiftRepsBody extends StatefulWidget {
  const GiftRepsBody({super.key});

  @override
  State<GiftRepsBody> createState() => _GiftRepsBodyState();
}

class _GiftRepsBodyState extends State<GiftRepsBody> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<GiftRepsBloc, GiftRepsState>(
        listener: (context, state) {
      if (state.status == GiftRepsStatus.giftSuccess) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GiftRepsSuccessDialog(
              amount:
                  state.listGifts?[state.giftIdSelected ?? 0].numberOfREPs ?? 0,
            );
          },
        );
      }
    }, builder: (context, state) {
      return state.listGifts != []
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          Constants.supportYourInstructorWithReps,
                          style: AppTextStyles.montserratStyle.bold16Black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          AppIcons.close.svgAssetPath,
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    Constants.selectAmountOfRepsToSendToTheInstructor,
                    style: AppTextStyles.montserratStyle.regular14Black,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 68,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          context
                              .read<GiftRepsBloc>()
                              .add(GiftRepsSelectedGiftEvent(index));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: index == state.giftIdSelected
                                ? AppColors.bubbles
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Image.network(
                            state.listGifts?[index].image ?? '',
                            height: 68,
                            width: size.width * 0.15,
                          ),
                        ),
                      ),
                      separatorBuilder: (_, __) => const SizedBox(width: 5),
                      itemCount: state.listGifts?.length ?? 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        context
                            .read<GiftRepsBloc>()
                            .add(GiftRepsSelectedTitleEvent(index));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                        decoration: BoxDecoration(
                          color: index == state.titleGiftIdSelected
                              ? AppColors.bubbles
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: index == state.titleGiftIdSelected
                                ? AppColors.tiffanyBlue
                                : AppColors.chineseSilver,
                          ),
                        ),
                        child: Text(
                          GiftRepMessageType.values[index].title,
                          style: AppTextStyles.montserratStyle.bold16Black,
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemCount: GiftRepMessageType.values.length,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: state.isSendEnabled
                      ? () {
                          context
                              .read<GiftRepsBloc>()
                              .add(const GiftRepsSendGiftEvent());
                        }
                      : null,
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(left: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      color: state.isSendEnabled
                          ? AppColors.tiffanyBlue
                          : AppColors.spanishGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${Constants.send} ',
                            style: AppTextStyles.montserratStyle.bold16White,
                          ),
                          TextSpan(
                            text: state.giftIdSelected == -1
                                ? '__'
                                : state.listGifts?[state.giftIdSelected ?? 0]
                                    .numberOfREPs
                                    .toString(),
                            style: AppTextStyles.montserratStyle.bold16White,
                          ),
                          TextSpan(
                            text: Constants.reps,
                            style: AppTextStyles.montserratStyle.bold16White,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.pineGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: Constants.youHave,
                                  style: AppTextStyles
                                      .montserratStyle.regular17White),
                              TextSpan(
                                  text: state.user?.numberOfREPs.toString(),
                                  style: AppTextStyles
                                      .montserratStyle.bold17White),
                              TextSpan(
                                  text: Constants.reps,
                                  style: AppTextStyles
                                      .montserratStyle.bold17White),
                            ],
                          ),
                        ),
                      ),
                      CustomButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        isExpanded: false,
                        backgroundColor: AppColors.tiffanyBlue,
                        title: Constants.getReps,
                        titleStyle: AppTextStyles.montserratStyle.bold15White,
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BuyRepDialog(
                                isBack: true,
                                numberOfREPs: state.user?.numberOfREPs ?? 0,
                                reps: state.reps ?? [],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink();
    });
  }
}
