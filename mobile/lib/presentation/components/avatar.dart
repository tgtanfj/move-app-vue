import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_images.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final bool isLive;
  final double widthAvatar;
  final double heightAvatar;
  final double radiusAvatar;

  const Avatar({
    super.key,
    required this.imageUrl,
    this.isLive = false,
    required this.widthAvatar,
    required this.heightAvatar,
    required this.radiusAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthAvatar,
      height: heightAvatar,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isLive ? Colors.red : Colors.transparent,
          width: 3.0,
        ),
      ),
      child: CircleAvatar(
        radius: radiusAvatar,
        backgroundImage: imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : AssetImage(AppImages.defaultAvatar.webpAssetPath),
      ),
    );
  }
}
