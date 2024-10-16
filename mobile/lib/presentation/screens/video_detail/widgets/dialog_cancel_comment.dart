import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_icons.dart';
import '../../../components/custom_button.dart';

class DialogCancelComment extends StatefulWidget {
  final VoidCallback? onTapCancel;
  const DialogCancelComment({super.key, this.onTapCancel});

  @override
  State<DialogCancelComment> createState() => _DialogCancelCommentState();
}

class _DialogCancelCommentState extends State<DialogCancelComment> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    Constants.cancelComment,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.montserratStyle.bold16Black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AppIcons.close.svgAssetPath,
                      height: 16,
                      width: 16,
                    )),
              ],
            ),
            const SizedBox(height: 8,),
            Text(
              Constants.areUSure,
              textAlign: TextAlign.left,
              style: AppTextStyles.montserratStyle.regular14Black,
            ),
            const SizedBox(height: 32,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 104,
                  height: 48,
                  child: CustomButton(
                    title: Constants.no,
                    titleStyle:
                    AppTextStyles.montserratStyle.regular16TiffanyBlue,
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.white,
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  width: 104,
                  height: 48,
                  child: CustomButton(
                    title: Constants.yes,
                    onTap: widget.onTapCancel,
                    titleStyle: AppTextStyles.montserratStyle.bold16White,
                    backgroundColor: AppColors.tiffanyBlue,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
