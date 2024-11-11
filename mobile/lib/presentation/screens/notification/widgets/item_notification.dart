import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/data/models/notification_model.dart';
import 'package:move_app/presentation/screens/notification/widgets/dialog_notice.dart';
import 'package:move_app/presentation/screens/notification/widgets/not_found_notification.dart';

import '../../../../utils/notification_messages.dart';
import '../../video_detail/page/video_detail_page.dart';

class ItemNotification extends StatefulWidget {
  final NotificationModel? notificationModel;
  final VoidCallback? onTapNotification;
  final bool hasDeleteNotification;

  const ItemNotification(
      {super.key,
      this.notificationModel,
      this.onTapNotification,
      this.hasDeleteNotification = true});

  @override
  State<ItemNotification> createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  String _getNotificationMessage(String type) {
    return NotificationMessages.prefixMessage[type] ??
        (type == NotificationType.viewVideoMilestone.value
            ? NotificationMessages.viewVideoMilestone(
                widget.notificationModel?.data.videoTitle ?? '')
            : '');
  }

  String _getMainContentMessageNotification() {
    return NotificationMessages.mainContentMessage(widget.notificationModel);
  }

  String _getSufMessageNotification() {
    return NotificationMessages.suffixMessage(widget.notificationModel);
  }

  String _getAfterSufMessageNotification() {
    return NotificationMessages.afterSufMessage(widget.notificationModel);
  }

  void _handleNotificationTap(String type) {
    final data = widget.notificationModel?.data;

    if (type == NotificationType.like.value ||
        type == NotificationType.comment.value ||
        type == NotificationType.reply.value ||
        type == NotificationType.upload.value) {
      (widget.notificationModel?.hasDelete ?? false)
          ? Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NotFoundNotification()))
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoDetailPage(
                  videoId: data?.videoId ?? 0,
                  targetCommentId: data?.commentId ?? 0,
                  targetReplyId: data?.replyId ?? 0,
                ),
              ),
            );
    } else {
      showDialog(
        context: context,
        builder: (_) => const DialogNotice(),
      );
    }
  }

  Widget _buildUserAvatar() {
    final avatarUrl = widget.notificationModel?.data.userModel?.avatar;
    final username = widget.notificationModel?.data.userModel?.username;

    if (avatarUrl == null || avatarUrl.isEmpty) {
      if (username != null && username.isNotEmpty) {
        return Image.asset(
          AppImages.moveWhite.pngAssetPath,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        );
      }
      return SvgPicture.asset(
        AppIcons.artboardMove.svgAssetPath,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      avatarUrl,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Image.asset(
          AppImages.moveWhite.pngAssetPath,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildNotificationContent() {
    final data = widget.notificationModel?.data;
    final message = _getNotificationMessage(data?.type.value ?? "");
    final mainContentMessage = _getMainContentMessageNotification();
    final sufMessage = _getSufMessageNotification();
    final afterSufMessage = _getAfterSufMessageNotification();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.montserratStyle.regular14White,
            children: [
              TextSpan(
                text: data?.userModel?.username ?? "",
                style: AppTextStyles.montserratStyle.bold14White,
              ),
              TextSpan(text: message),
              TextSpan(
                  text: mainContentMessage,
                  style: AppTextStyles.montserratStyle.bold14White),
              TextSpan(text: sufMessage),
              TextSpan(
                  text: afterSufMessage,
                  style: AppTextStyles.montserratStyle.bold14White),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.notificationModel?.formattedTime ?? "",
          style: AppTextStyles.montserratStyle.regular12SilverChalice,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTapNotification?.call();
        _handleNotificationTap(widget.notificationModel?.data.type.value ?? "");
      },
      child: Material(
        color: widget.notificationModel?.isRead ?? false
            ? AppColors.graniteGray
            : AppColors.black,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(child: _buildUserAvatar()),
              const SizedBox(width: 8),
              Expanded(child: _buildNotificationContent()),
            ],
          ),
        ),
      ),
    );
  }
}
