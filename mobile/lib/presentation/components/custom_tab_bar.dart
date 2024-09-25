import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

class CustomTabBar extends StatefulWidget {
  final Map<String, Widget> tabsWithViews;
  final EdgeInsetsGeometry? tabBarPadding;
  final TabAlignment? tabAlignment;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Color? indicatorColor;
  final double? dividerHeight;

  const CustomTabBar({
    super.key,
    required this.tabsWithViews,
    this.tabAlignment,
    this.labelStyle,
    this.labelPadding,
    this.tabBarPadding,
    this.unselectedLabelStyle,
    this.indicatorColor,
    this.dividerHeight,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabsWithViews.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.tabBarPadding ?? const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          TabBar(
            padding: EdgeInsets.zero,
            tabAlignment: widget.tabAlignment ?? TabAlignment.start,
            controller: _tabController,
            isScrollable: true,
            labelPadding:
                widget.labelPadding ?? const EdgeInsets.only(right: 32),
            labelStyle: widget.labelStyle ??
                AppTextStyles.montserratStyle.bold16tiffanyBlue,
            unselectedLabelStyle: widget.unselectedLabelStyle ??
                AppTextStyles.montserratStyle.regular16Black,
            indicatorWeight: widget.dividerHeight ?? 4,
            indicatorColor: widget.indicatorColor ?? AppColors.tiffanyBlue,
            dividerColor: Colors.white,
            tabs: widget.tabsWithViews.keys
                .map((tabTitle) => Tab(text: tabTitle))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabsWithViews.values.toList(),
            ),
          )
        ],
      ),
    );
  }
}
