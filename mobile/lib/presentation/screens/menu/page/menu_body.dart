import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/screens/buy_rep/page/buy_rep_page.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/buy_rep_dialog.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_bloc.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_event.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_state.dart';
import 'package:move_app/presentation/screens/menu/page/menu_had_login.dart';
import 'package:move_app/presentation/screens/menu/page/menu_not_login.dart';

import '../../../routes/app_routes.dart';

class MenuBody extends StatefulWidget {
  const MenuBody({super.key});

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          String token = SharedPrefer.sharedPrefer.getUserToken();
          return Column(
            children: [
              AppBarWidget(
                prefixIconPath: AppIcons.closeWhite.svgAssetPath,
                prefixButton: () => Navigator.of(context).pop(),
                isEnableSuffixIcon: token.isNotEmpty,
                suffixIconPath: AppIcons.notification.svgAssetPath,
                suffixButton: () {
                  Navigator.of(context).pushNamed(AppRoutes.routeNotification);
                },
              ),
              Expanded(
                child: state.status == MenuStatus.hadlogin
                    ? MenuHadLogin(
                        avatarPath: state.user?.avatar ?? '',
                        userName: state.user?.username ?? Constants.userName,
                        isBlueBadge: state.user?.isBlueBadge ?? false,
                        isPinkBadge: state.user?.isPinkBadge ?? false,
                        logoutSuccessEvent: () => context
                            .read<MenuBloc>()
                            .add(const MenuLogoutSuccessEvent()),
                        isMoreEnable: state.isEnableMore,
                        moreButton: () => context.read<MenuBloc>().add(
                            MenuSelectMoreEvent(
                                isMoreEnable: !state.isEnableMore)),
                        onBuyRep: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BuyRepDialog(
                                  numberOfREPs: state.user?.numberOfREPs ?? 0,
                                  reps: state.reps ?? [],
                                );
                              }).then((onValue) {
                            if (onValue != null) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BuyRepPage(
                                      rep: onValue,
                                    );
                                  });
                            }
                          });
                        },
                      )
                    : MenuNotLogin(
                        isMoreEnable: state.isEnableMore,
                        moreButton: () => context.read<MenuBloc>().add(
                            MenuSelectMoreEvent(
                                isMoreEnable: !state.isEnableMore)),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
