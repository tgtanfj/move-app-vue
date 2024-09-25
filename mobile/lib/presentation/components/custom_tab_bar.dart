import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabTitles;
  final List<Widget> widgets;

  const CustomTabBar(
      {super.key, required this.tabTitles, required this.widgets});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    int length = widget.tabTitles.length > widget.widgets.length
        ? widget.tabTitles.length
        : widget.widgets.length;

    _tabController = TabController(vsync: this, length: length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> adjustedTabTitles =
        widget.tabTitles.length < widget.widgets.length
            ? widget.tabTitles +
                List.generate(widget.widgets.length - widget.tabTitles.length,
                    (index) => Constants.tab)
            : widget.tabTitles;

    List<Widget> adjustedWidgets = widget.widgets.length <
            widget.tabTitles.length
        ? widget.widgets +
            List.generate(
                widget.tabTitles.length - widget.widgets.length,
                (index) => Center(
                    child:
                        Text(widget.tabTitles[widget.widgets.length + index])))
        : widget.widgets;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          tabs: adjustedTabTitles.map((title) => Tab(text: title)).toList(),
          controller: _tabController,
          isScrollable: true,
          labelStyle: AppTextStyles.montserratStyle.bold16tiffanyBlue,
          unselectedLabelStyle: AppTextStyles.montserratStyle.regular16Black,
          tabAlignment: TabAlignment.center,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4.0,
              color: AppColors.tiffanyBlue,
            ),
            insets: EdgeInsets.symmetric(horizontal: 0),
          ),
          indicatorSize: TabBarIndicatorSize.label,
          dividerHeight: 1,
        ),
        Expanded(
            child: TabBarView(
                controller: _tabController, children: adjustedWidgets))
      ],
    );
  }
}
