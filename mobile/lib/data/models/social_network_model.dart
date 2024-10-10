import 'package:move_app/config/theme/app_icons.dart';

class SocialNetworkModel {
  final String? name;
  final String? link;

  SocialNetworkModel({
    required this.name,
    required this.link,
  });

  SocialNetworkModel copyWith({
    String? name,
    String? link,
  }) {
    return SocialNetworkModel(
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }

  factory SocialNetworkModel.fromJson(Map<String, dynamic> json) {
    return SocialNetworkModel(
      name: json['name'] is int? ? json['name'] : '',
      link: json['link'] is String? ? json['link'] : '',
    );
  }

  String getIconPath() {
    switch (name) {
      case 'facebook':
        return AppIcons.facebookLogo.svgAssetPath;
      case 'twitter':
        return AppIcons.twitterLogo.svgAssetPath;
      case 'youtube':
        return AppIcons.youtubeLogo.svgAssetPath;
      default:
        return '';
    }
  }
}
