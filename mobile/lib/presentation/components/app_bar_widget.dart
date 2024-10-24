import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/search/page/search_result_page.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? prefixButton;
  final VoidCallback? suffixButton;
  final String? prefixIconPath;
  final String? suffixIconPath;
  final bool isShowNotificationDot;
  final bool isEnableSuffixIcon;
  final bool isEnablePrefixIcon;
  final String? title;
  final TextStyle? titleStyle;
  final TextAlign? titleAlign;
  final EdgeInsetsGeometry? paddingTitle;

  const AppBarWidget({
    super.key,
    this.prefixButton,
    this.suffixButton,
    this.prefixIconPath,
    this.suffixIconPath,
    this.isShowNotificationDot = false,
    this.isEnableSuffixIcon = true,
    this.isEnablePrefixIcon = true,
    this.title,
    this.titleStyle,
    this.paddingTitle,
    this.titleAlign,
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
        widget.isEnablePrefixIcon
            ? GestureDetector(
                onTap: widget.prefixButton ??
                    () => Navigator.pushNamed(context, AppRoutes.routeMenu),
                child: SizedBox(
                  width: 35,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(
                          widget.prefixIconPath ?? AppIcons.drawer.svgAssetPath,
                          height: 18.0,
                          width: 27.0,
                        ),
                      ),
                      Positioned(
                        top: 13,
                        right: 0,
                        child: Visibility(
                            visible: widget.prefixIconPath == null &&
                                widget.isShowNotificationDot,
                            child: SvgPicture.asset(
                              AppIcons.redDot.svgAssetPath,
                              height: 16,
                              width: 16,
                            )),
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        Expanded(
          child: widget.title != null
              ? Padding(
                  padding: widget.paddingTitle ?? EdgeInsets.zero,
                  child: Text(
                    widget.title ?? "",
                    style: widget.titleStyle,
                    textAlign: widget.titleAlign,
                  ),
                )
              : GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.home, (route) => false),
                  child: SvgPicture.asset(
                    AppIcons.moveWhiteTextLogo.svgAssetPath,
                  ),
                ),
        ),
        widget.isEnableSuffixIcon
            ? GestureDetector(
                onTap: widget.suffixButton ??
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchResultPage())),
                child: SizedBox(
                  width: 32,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(
                          widget.suffixIconPath ?? AppIcons.search.svgAssetPath,
                          width: 24.0,
                          height: 24.0,
                        ),
                      ),
                      Positioned(
                        top: 13,
                        right: 0,
                        child: Visibility(
                            visible: widget.prefixIconPath != null &&
                                widget.isShowNotificationDot,
                            child: SvgPicture.asset(
                              AppIcons.redDot.svgAssetPath,
                              height: 16,
                              width: 16,
                            )),
                      )
                    ],
                  ),
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
