import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_section_title.dart';
import 'package:move_app/presentation/components/custom_tab_bar.dart';
import 'package:move_app/presentation/screens/setting/bloc/setting_bloc.dart';
import 'package:move_app/presentation/screens/setting/bloc/setting_state.dart';

import '../../../../constants/constants.dart';
import '../presentation/profile/page/profile_page.dart';

class SettingBody extends StatefulWidget {
  const SettingBody({super.key});

  @override
  State<SettingBody> createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {},
      child: BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBarWidget(
            prefixButton: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: AppColors.white,
          body: const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSectionTitle(title: Constants.settings),
                  Expanded(
                    child: CustomTabBar(tabsWithViews: {
                      Constants.profile: ProfilePage(),
                      Constants.notifications: SizedBox(),
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
