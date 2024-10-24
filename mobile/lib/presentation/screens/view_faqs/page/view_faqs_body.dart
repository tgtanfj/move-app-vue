import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_tile.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_bloc.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_event.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_state.dart';

class ViewFAQsBody extends StatefulWidget {
  const ViewFAQsBody({super.key});

  @override
  State<ViewFAQsBody> createState() => _ViewFAQsBodyState();
}

class _ViewFAQsBodyState extends State<ViewFAQsBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppIcons.faqs.svgAssetPath,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ViewFaqsBloc, ViewFaqsState>(
            builder: (context, state) {
              if (state.status == ViewFaqsStatus.loading) {
                EasyLoading.show();
              } else if (state.status == ViewFaqsStatus.loaded) {
                EasyLoading.dismiss();
                final faqs = state.faqs ?? [];
                return Expanded(
                  child: faqs.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          shrinkWrap: true,
                          itemCount: faqs.length,
                          itemBuilder: (context, index) => CustomTile(
                            isExpanded:
                                state.isExpanded?[faqs[index].id] ?? false,
                            onTap: () {
                              context.read<ViewFaqsBloc>().add(
                                  ViewFaqsClickEvent(
                                      faqId: faqs[index].id ?? 0));
                            },
                            title: faqs[index].question ?? '',
                            titleStyle:
                                AppTextStyles.montserratStyle.bold16black,
                            expandedContent: Text(
                              faqs[index].answer ?? '',
                              style:
                                  AppTextStyles.montserratStyle.regular16Black,
                            ),
                          ),
                        )
                      : const Center(child: Text(Constants.noData)),
                );
              } else if (state.status == ViewFaqsStatus.error) {
                return Center(child: Text(state.errorMessage ?? ''));
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
