import 'package:flutter/material.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/comment_model.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/dialog_cancel_comment.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_images.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../auth/widgets/dialog_authentication.dart';

class WriteComment extends StatefulWidget {
  final VoidCallback? onTapCancel;
  final VoidCallback? onTapSend;
  final ValueChanged<String>? onChanged;
  final double? marginLeft;
  final CommentModel? commentModel;
  final String? hintText;
  final bool? isCancelReply;

  const WriteComment({
    super.key,
    this.onTapCancel,
    this.onTapSend,
    this.onChanged,
    this.marginLeft = 12,
    this.commentModel,
    this.hintText,
    this.isCancelReply = false,
  });

  @override
  State<WriteComment> createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  bool hasValue = false;
  final TextEditingController controller = TextEditingController();
  String avatarUrl = SharedPrefer.sharedPrefer.getUserAvatarUrl();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
                  child: avatarUrl == ""
                      ? Image.asset(
                          AppImages.defaultAvatar.webpAssetPath,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          avatarUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (SharedPrefer.sharedPrefer.getUserToken().isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const DialogAuthentication();
                        },
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: SharedPrefer.sharedPrefer.getUserToken().isEmpty,
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
                        hintText: widget.hintText ?? Constants.writeComment,
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
                      if (widget.isCancelReply == true) {
                        FocusScope.of(context).unfocus();
                        controller.clear();
                        widget.onTapCancel?.call();
                        setState(() {
                          hasValue = false;
                        });
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return DialogCancelComment(
                            onTapCancel: () {
                              widget.onTapCancel?.call();
                              controller.clear();
                              setState(() {
                                hasValue = false;
                              });
                              Navigator.of(context).pop();
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
                    onTap: () {
                      widget.onTapSend?.call();
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasValue = false;
                      });
                      controller.clear();
                    },
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
