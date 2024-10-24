import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/presentation/screens/gift_reps/page/gift_rep_page.dart';

class GiftRepsDialog extends StatefulWidget {
  final int? videoId;
  const GiftRepsDialog({
    super.key,
    this.videoId,
  });

  @override
  State<GiftRepsDialog> createState() => _GiftRepsDialogState();
}

class _GiftRepsDialogState extends State<GiftRepsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      child: GiftRepPage(
        videoId: widget.videoId ,
      ),
    );
  }
}
