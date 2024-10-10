import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_icons.dart';

class SearchHistoryWidgets extends StatelessWidget {
  final String? searchItem;
  final VoidCallback? onPress;
  final VoidCallback? onTap;
  const SearchHistoryWidgets({super.key, this.searchItem, this.onPress, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(searchItem ?? ""),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize
                .shrinkWrap),
        icon: SvgPicture.asset(
          AppIcons.closeCircle.svgAssetPath,
          color: AppColors.chineseSilver,
          width: 24,
          height: 24,
        ),
        onPressed: () => onPress,
      ),
      onTap: () => onTap,
    );
  }
}
