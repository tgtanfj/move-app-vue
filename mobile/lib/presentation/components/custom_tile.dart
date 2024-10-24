import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class CustomTile extends StatefulWidget {
  final String title;
  final TextStyle titleStyle;
  final Widget? expandedContent;
  final VoidCallback onTap;
  final bool isExpanded;
  const CustomTile(
      {super.key,
      required this.title,
      this.expandedContent,
      required this.titleStyle,
      required this.onTap,
      this.isExpanded = false});

  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD6D5D5).withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(-3, 3),
            ),
            BoxShadow(
              color: const Color(0xFFD6D5D5).withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(3, 3),
            ),
          ]),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                    child: Text(
                      widget.title,
                      style: widget.isExpanded
                          ? AppTextStyles.montserratStyle.bold16TiffanyBlue
                          : widget.titleStyle,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.isExpanded ? Icons.remove : Icons.add,
                    color: widget.isExpanded
                        ? AppColors.tiffanyBlue
                        : AppColors.black,
                  ),
                  onPressed: widget.onTap,
                ),
              ],
            ),
          ),
          if (widget.isExpanded && widget.expandedContent != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: widget.expandedContent,
            ),
        ],
      ),
    );
  }
}
