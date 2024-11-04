import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/custom_share_button.dart';

import '../../../../config/theme/app_icons.dart';

class ShareVideoDialog extends StatefulWidget {
  final VoidCallback? onFacebookTap;
  final VoidCallback? onTwitterTap;
  final VoidCallback? onCopyLinkTap;
  const ShareVideoDialog({
    super.key,
    this.onFacebookTap,
    this.onTwitterTap,
    this.onCopyLinkTap,
  });

  @override
  State<ShareVideoDialog> createState() => _ShareVideoDialogState();
}

class _ShareVideoDialogState extends State<ShareVideoDialog> {
  bool isCopied = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isCopied == true)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.copied.svgAssetPath,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Text(
                    Constants.linkCopied,
                    style: AppTextStyles.montserratStyle.regular16Black,
                  ),
                ],
              ),
            ),
          ),
        Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: AppColors.white,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Constants.shareVia,
                        style: AppTextStyles.montserratStyle.bold20Black,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          AppIcons.close.svgAssetPath,
                          height: 16,
                          width: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomShareButton(
                        title: Constants.facebookOption,
                        iconPath: AppIcons.facebookLogo.svgAssetPath,
                        onCopyTap: widget.onFacebookTap,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      CustomShareButton(
                        title: Constants.twitterOption,
                        iconPath: AppIcons.twitterLogo.svgAssetPath,
                        onCopyTap: widget.onTwitterTap,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      CustomShareButton(
                        onCopyTap: () {
                          setState(() {
                            isCopied = true;
                          });
                          widget.onCopyLinkTap?.call();
                        },
                        title: Constants.copyLink,
                        iconPath: AppIcons.copied.svgAssetPath,
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
