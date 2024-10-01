import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.black,
      actions: [
        const SizedBox(
          width: 20.0,
        ),
        GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            AppIcons.drawer.svgAssetPath,
            height: 18.0,
            width: 27.0,
          ),
        ),
        Expanded(
          child: SvgPicture.asset(
            AppIcons.moveWhiteTextLogo.svgAssetPath,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            AppIcons.search.svgAssetPath,
            width: 24.0,
            height: 24.0,
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}
