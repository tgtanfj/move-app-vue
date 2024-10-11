import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/presentation/screens/home/page/home_page.dart';

class CustomSearchBox extends StatefulWidget implements PreferredSizeWidget {
  final String hintText;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final TextInputType? textInputType;
  final Widget? suffix;
  final TextCapitalization? textCapitalization;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final double borderRadius;
  final Function? onSearch;
  final ValueChanged? onSubmitted;
  final TextEditingController? controller;
  final bool autoFocus;
  final FocusNode? focusNode;

  const CustomSearchBox({
    super.key,
    this.hintText = '',
    this.textStyle,
    this.hintTextStyle,
    this.textInputType,
    this.padding,
    this.borderRadius = 16,
    this.backgroundColor = Colors.white,
    this.suffix,
    this.textCapitalization,
    this.onSearch,
    this.onSubmitted,
    this.controller,
    this.autoFocus = false,
    this.focusNode,
  });

  @override
  State<CustomSearchBox> createState() => _CustomSearchBoxState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomSearchBoxState extends State<CustomSearchBox> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.black,
      actions: [
        IconButton(
          iconSize: 24,
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          icon: SvgPicture.asset(AppIcons.back.svgAssetPath),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 7, bottom: 9),
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.backgroundColor,
            ),
            child: TextField(
              controller: widget.controller,
              style: widget.textStyle,
              autofocus: widget.autoFocus,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: widget.hintTextStyle,
                suffixIcon: widget.suffix,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: widget.onSubmitted,
              keyboardType: widget.textInputType,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.none,
            ),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}
