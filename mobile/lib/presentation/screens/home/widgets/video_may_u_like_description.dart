import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/avatar.dart';
import 'package:move_app/presentation/components/badges.dart';
import 'package:move_app/presentation/components/star_and_text.dart';
import 'package:move_app/presentation/components/type_label.dart';

class VideoMayULikeDescription extends StatelessWidget {
  const VideoMayULikeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40.0,
          child: Row(
            children: [
              const Avatar(
                  heightAvatar: 31.0,
                  widthAvatar: 31.0,
                  radiusAvatar: 27.0,
                  imageUrl:
                      'https://www.1zoom.me/big2/946/289597-frederika.jpg'),
              Flexible(
                child: Text(
                  'DianaTv',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppTextStyles.montserratStyle.regular14graniteGray,
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              const Badges(
                isBlueBadge: true,
                isPinkBadge: true,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                'Title goes here..sss..ssssssssssss',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.montserratStyle.regular14graniteGray,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            StarAndText(
              textStyle: AppTextStyles.montserratStyle.bold14Black,
            ),
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(children: [
          Expanded(
            child: Text(
              'Just Move • Just Day Ago',
              style: AppTextStyles.montserratStyle.regular14graniteGray,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
        const SizedBox(
          height: 4.0,
        ),
        const Row(
          children: [
            Flexible(
              child: TypeLabel(
                typeLabel: Constants.intermediate == 'Intermediate'
                    ? Constants.interm
                    : Constants.intermediate,
              ),
            ),
            SizedBox(
              width: 3.0,
            ),
            TypeLabel(typeLabel: '<30 mins'),
          ],
        )
      ],
    );
  }
}
