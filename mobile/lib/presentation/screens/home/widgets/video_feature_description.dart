import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/presentation/components/avatar.dart';
import 'package:move_app/presentation/components/badges.dart';
import 'package:move_app/presentation/components/star_and_text.dart';
import 'package:move_app/presentation/components/type_label.dart';

class VideoFeatureDescription extends StatefulWidget {
  const VideoFeatureDescription({super.key});

  @override
  State<VideoFeatureDescription> createState() =>
      _VideoFeatureDescriptionState();
}

class _VideoFeatureDescriptionState extends State<VideoFeatureDescription> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Avatar(
                heightAvatar: 40.0,
                widthAvatar: 40.0,
                radiusAvatar: 32.0,
                imageUrl: 'https://www.1zoom.me/big2/946/289597-frederika.jpg'), // TODO: add user avatar
            const SizedBox(
              width: 13.0,
            ),
            Expanded(
              child: Text(
                'Leg days ', // TODO: add title
                style: AppTextStyles.montserratStyle.bold18black,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            StarAndText(
              textStyle: AppTextStyles.montserratStyle.bold16black,
            ),
            const SizedBox(
              width: 8.0,
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 53.0,
            ),
            Flexible(
              child: Text(
                'Name of Personss', // TODO: add nameuser
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.montserratStyle.regular14graniteGray,
              ),
            ),
            const Badges(),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 53.0,
            ),
            Text(
              'Just More', // TODO: add category
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.montserratStyle.regular14graniteGray,
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        const Row(
          children: [
            SizedBox(
              width: 53.0,
            ),
            TypeLabel(typeLabel: 'Intermediate'), // ToDO: add type
            SizedBox(
              width: 9.0,
            ),
            TypeLabel(typeLabel: '<30 mins'), // TODO: add type time
          ],
        )
      ],
    );
  }
}
