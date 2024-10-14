import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/data/models/social_network_model.dart';

class SocialNetworkWidget extends StatelessWidget {
  final List<SocialNetworkModel> socialNetworks;
  final Function(String)? onTapSocialNetwork;

  const SocialNetworkWidget({
    super.key,
    required this.socialNetworks,
    this.onTapSocialNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return socialNetworkItem(
            socialNetworks[index],
            () {
              if (socialNetworks[index].link != null) {
                onTapSocialNetwork?.call(socialNetworks[index].link!);
              }
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemCount: socialNetworks.length,
      ),
    );
  }

  Widget socialNetworkItem(SocialNetworkModel item, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        item.getIconPath(),
        width: 40,
        height: 40,
      ),
    );
  }
}
