import 'package:flutter/material.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/dialog_cancel_comment.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_images.dart';
import '../../../../config/theme/app_text_styles.dart';

class WriteComment extends StatefulWidget {
  final VoidCallback? onTapCancel;
  final VoidCallback? onTapSend;
  final ValueChanged<String>? onChanged;
  final double? marginLeft;

  const WriteComment({super.key,
    this.onTapCancel,
    this.onTapSend,
    this.onChanged,
    this.marginLeft = 12,});

  @override
  State<WriteComment> createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  bool hasValue = false;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: widget.marginLeft,
              ),
              ClipOval(
                  child: Image.asset(
                    AppImages.posterVideo.pngAssetPath,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  )
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    setState(() {
                      hasValue = value.isNotEmpty;
                    });
                  },
                  style: AppTextStyles.montserratStyle.regular14Black,
                  decoration: InputDecoration(
                    hintText: Constants.writeComment,
                    hintStyle:
                    AppTextStyles.montserratStyle.regular14GraniteGray,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Visibility(
            visible: hasValue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 104,
                  height: 48,
                  child: CustomButton(
                    title: Constants.cancel,
                    titleStyle:
                    AppTextStyles.montserratStyle.regular16TiffanyBlue,
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.white,
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return DialogCancelComment(
                            onTapCancel: () {
                              controller.clear();
                              widget.onTapCancel?.call();
                              setState(() {
                                hasValue = false;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 104,
                  height: 48,
                  child: CustomButton(
                    title: Constants.send,
                    onTap: widget.onTapSend,
                    titleStyle: AppTextStyles.montserratStyle.bold16White,
                    backgroundColor: AppColors.tiffanyBlue,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
    );
  }
}
