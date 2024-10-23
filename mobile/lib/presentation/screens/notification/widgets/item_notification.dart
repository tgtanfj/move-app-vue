import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/data/models/notification_model.dart';

class ItemNotification extends StatefulWidget {
  final NotificationModel? notificationModel;
  final VoidCallback? onTapNotification;

  const ItemNotification({
    super.key,
    this.notificationModel,
    this.onTapNotification,
  });

  @override
  State<ItemNotification> createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapNotification,
      child: Material(
        color: widget.notificationModel?.hasRead ?? false
            ? AppColors.graniteGray
            : AppColors.black,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                  child: widget.notificationModel?.userModel?.avatar?.isEmpty ??
                          true
                      ? SvgPicture.asset(
                          AppIcons.artboardMove.svgAssetPath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.notificationModel?.userModel?.avatar ?? "",
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.montserratStyle.regular14White,
                        children: [
                          TextSpan(
                            text:
                                widget.notificationModel?.userModel?.username ??
                                    "",
                            style: AppTextStyles.montserratStyle.bold14White,
                          ),
                          TextSpan(
                            text: widget.notificationModel?.content ?? "",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.notificationModel?.createTime ?? "",
                      style:
                          AppTextStyles.montserratStyle.regular12SilverChalice,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
