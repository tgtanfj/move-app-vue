import 'package:move_app/data/models/social_network_model.dart';

class ChannelModel {
  final int? id;
  final String? name;
  final String? bio;
  final String? image;
  final bool isBlueBadge;
  final bool isPinkBadge;
  final List<SocialNetworkModel>? socialLinks;
  final int? numberOfFollowers;
  final bool? isFollowed;
  final List<ChannelModel>? followingChannels;
  final bool? canFollow;

  ChannelModel({
    this.id,
    this.name,
    this.bio,
    this.image,
    this.isBlueBadge = false,
    this.isPinkBadge = false,
    this.socialLinks,
    this.isFollowed,
    this.followingChannels,
    this.numberOfFollowers,
    this.canFollow,
  });

  ChannelModel copyWith({
    int? id,
    String? name,
    String? bio,
    String? image,
    bool? isBlueBadge,
    bool? isPinkBadge,
    List<SocialNetworkModel>? socialLinks,
    bool? isFollowed,
    List<ChannelModel>? followingChannels,
    int? numberOfFollowers,
    bool? canFollow,
  }) {
    return ChannelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      isBlueBadge: isBlueBadge ?? this.isBlueBadge,
      isPinkBadge: isPinkBadge ?? this.isPinkBadge,
      socialLinks: socialLinks ?? this.socialLinks,
      numberOfFollowers: numberOfFollowers ?? this.numberOfFollowers,
      followingChannels: followingChannels ?? this.followingChannels,
      isFollowed: isFollowed ?? this.isFollowed,
      canFollow: canFollow ?? this.canFollow,
    );
  }

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] is int? ? json['id'] : 0,
      name: json['name'] is String? ? json['name'] : '',
      bio: json['bio'] is String? ? json['bio'] : '',
      image: json['image'] is String? ? json['image'] : '',
      isBlueBadge: json['isBlueBadge'] is bool? ? json['isBlueBadge'] : false,
      isPinkBadge: json['isPinkBadge'] is bool? ? json['isPinkBadge'] : false,
      socialLinks: (json['socialLinks'] as List<dynamic>?)
          ?.map((e) => SocialNetworkModel.fromJson(e))
          .toList(),
      numberOfFollowers:
          json['numberOfFollowers'] is num? ? json['numberOfFollowers'] : 0,
      followingChannels: (json['followingChannels'] as List<dynamic>?)
          ?.map((e) => ChannelModel.fromJson(e))
          .toList(),
      isFollowed: json['isFollowed'] is bool? ? json['isFollowed'] : false,
      canFollow: json['canFollow'] is bool? ? json['canFollow'] : false,
    );
  }
}
