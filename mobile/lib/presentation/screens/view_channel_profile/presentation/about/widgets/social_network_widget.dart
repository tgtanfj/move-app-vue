import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/data/models/social_network_model.dart';

class SocialNetworkWidget extends StatelessWidget {
  final List<SocialNetworkModel> socialNetworks;

  const SocialNetworkWidget({super.key, required this.socialNetworks});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return socialNetworkItem(socialNetworks[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemCount: socialNetworks.length),
    );
  }

  Widget socialNetworkItem(SocialNetworkModel item) {
    return SvgPicture.asset(
      item.getIconPath(),
      width: 40,
      height: 40,
    );
  }
}
