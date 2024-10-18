import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_bloc.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_event.dart';
import 'package:move_app/presentation/screens/menu/bloc/menu_state.dart';
import 'package:move_app/presentation/screens/menu/page/menu_had_login.dart';
import 'package:move_app/presentation/screens/menu/page/menu_not_login.dart';

class MenuBody extends StatefulWidget {
  const MenuBody({super.key});

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        prefixIconPath: AppIcons.closeWhite.svgAssetPath,
        prefixButton: () => Navigator.of(context).pop(),
        suffixIconPath: AppIcons.notification.svgAssetPath,
      ),
      backgroundColor: AppColors.black,
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state.status == MenuStatus.hadlogin) {
            return MenuHadLogin(
              avatarPath: state.user?.avatar ?? '' ,
              userName: state.user?.username ?? Constants.userName,
              isBlueBadge: state.user?.isBlueBadge ?? false,
              isPinkBadge: state.user?.isPinkBadge ?? false,
              logoutSuccessEvent: () =>
                  context.read<MenuBloc>().add(const MenuLogoutSuccessEvent()),
              isMoreEnable: state.isEnableMore,
              moreButton: () => context
                  .read<MenuBloc>()
                  .add(MenuSelectMoreEvent(isMoreEnable: !state.isEnableMore)),
            );
          } else {
            return MenuNotLogin(
              isMoreEnable: state.isEnableMore,
              moreButton: () => context
                  .read<MenuBloc>()
                  .add(MenuSelectMoreEvent(isMoreEnable: !state.isEnableMore)),
            );
          }
        },
      ),
    );
  }
}
