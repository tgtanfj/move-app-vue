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
  final double marginLeft;
  final double marginRight;
  final CommentModel? commentModel;
  final String? hintText;
  final bool isCancelReply;

  const WriteComment({
    super.key,
    this.onTapCancel,
    this.onTapSend,
    this.onChanged,
    this.marginLeft = 12,
    this.marginRight = 12,
    this.commentModel,
    this.hintText,
    this.isCancelReply = false,
  });

  @override
  State<WriteComment> createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  bool hasValue = false;
  bool isFocused = false;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final String avatarUrl = SharedPrefer.sharedPrefer.getUserAvatarUrl();

  @override
  void initState() {
    super.initState();
    _initializeFocusListener();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _initializeFocusListener() {
    focusNode.addListener(() {
      setState(() => isFocused = focusNode.hasFocus);
    });
  }

  void clearComment() {
    controller.clear();
    focusNode.unfocus();
    setState(() {
      hasValue = false;
      isFocused = false;
    });
  }

  void _handleCancel() {
    if (widget.isCancelReply) {
      clearComment();
      widget.onTapCancel?.call();
    } else if (hasValue) {
      _showCancelDialog();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogCancelComment(
          onTapCancel: () {
            widget.onTapCancel?.call();
            Navigator.of(context).pop();
            clearComment();
          },
        );
      },
    );
  }

  void _handleSend() {
    if (hasValue) {
      widget.onTapSend?.call();
      clearComment();
    }
  }

  Widget _buildAvatar() {
    return ClipOval(
      child: avatarUrl.isEmpty
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
              errorBuilder: (_, __, ___) => Image.asset(
                AppImages.defaultAvatar.webpAssetPath,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget _buildTextField() {
    return GestureDetector(
      onTap: () {
        if (SharedPrefer.sharedPrefer.getUserToken().isEmpty) {
          _showAuthenticationDialog();
        }
      },
      child: AbsorbPointer(
        absorbing: SharedPrefer.sharedPrefer.getUserToken().isEmpty,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: null,
          onChanged: (value) {
            widget.onChanged?.call(value);
            setState(() => hasValue = value.trim().isNotEmpty);
          },
          style: AppTextStyles.montserratStyle.regular14Black,
          decoration: InputDecoration(
            hintText: widget.hintText ?? Constants.writeComment,
            hintStyle: AppTextStyles.montserratStyle.regular14GraniteGray,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.tiffanyBlue),
            ),
          ),
        ),
      ),
    );
  }

  void _showAuthenticationDialog() {
    showDialog(
      context: context,
      builder: (_) => const DialogAuthentication(),
    );
  }

  Widget _buildActionButtons() {
    return Visibility(
      visible: isFocused || hasValue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCancelButton(),
          const SizedBox(width: 12),
          _buildSendButton(),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: 104,
      height: 48,
      child: CustomButton(
        title: Constants.cancel,
        titleStyle: AppTextStyles.montserratStyle.regular16TiffanyBlue,
        backgroundColor: AppColors.white,
        borderColor: AppColors.white,
        onTap: _handleCancel,
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: 104,
      height: 48,
      child: CustomButton(
        title: Constants.send,
        titleStyle: AppTextStyles.montserratStyle.bold16White,
        backgroundColor:
            hasValue ? AppColors.tiffanyBlue : AppColors.spanishGray,
        borderColor: hasValue ? AppColors.tiffanyBlue : AppColors.spanishGray,
        onTap: _handleSend,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: widget.marginLeft),
                _buildAvatar(),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField()),
                SizedBox(width: widget.marginRight),
              ],
            ),
            const SizedBox(height: 8),
            _buildActionButtons(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
