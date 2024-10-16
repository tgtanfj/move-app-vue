import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/presentation/routes/app_routes.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? prefixButton;
  final VoidCallback? suffixButton;
  final String? prefixIconPath;
  final String? suffixIconPath;
  final bool isEnableIcon;

  const AppBarWidget({
    super.key,
    this.prefixButton,
    this.suffixButton,
    this.prefixIconPath,
    this.suffixIconPath,
    this.isEnableIcon = true,
  });

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
        widget.isEnableIcon
            ? GestureDetector(
                onTap: widget.prefixButton ??
                    () => Navigator.pushNamed(context, AppRoutes.routeMenu),
                child: SvgPicture.asset(
                  widget.prefixIconPath ?? AppIcons.drawer.svgAssetPath,
                  height: 18.0,
                  width: 27.0,
                ),
              )
            : const SizedBox(),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.home),
            child: SvgPicture.asset(
              AppIcons.moveWhiteTextLogo.svgAssetPath,
            ),
          ),
        ),
        widget.isEnableIcon
            ? GestureDetector(
                onTap: widget.suffixButton,
                child: SvgPicture.asset(
                  widget.suffixIconPath ?? AppIcons.search.svgAssetPath,
                  width: 24.0,
                  height: 24.0,
                ),
              )
            : const SizedBox(),
        const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}
