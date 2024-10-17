import 'package:move_app/data/models/following_channel_model.dart';
import 'package:move_app/data/models/social_network_model.dart';

class ChannelModel {
  final int id;
  final String? name;
  final String? bio;
  final String? image;
  final bool isBlueBadge;
  final bool isPinkBadge;
  final List<SocialNetworkModel>? socialLinks;
  final int? numberOfFollowed;
  final bool? isFollowed;
  final List<FollowingChannelModel>? followingChannels;
  final String? numberOfFollowers;

  ChannelModel({  
    required this.id,  
    this.name,
    this.bio,
    this.image,
    this.isBlueBadge = false,
    this.isPinkBadge = false,
    this.socialLinks,
    this.numberOfFollowed,
    this.isFollowed,
    this.followingChannels,
    this.numberOfFollowers,
  });

  ChannelModel copyWith({
    String? name,
    String? bio,
    String? image,
    bool? isBlueBadge,
    bool? isPinkBadge,
    List<SocialNetworkModel>? socialLinks,
    int? numberOfFollowed,
    bool? isFollowed,
    List<FollowingChannelModel>? followingChannels,
    String? numberOfFollowers,
  }) {
    return ChannelModel(
      id: id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      isBlueBadge: isBlueBadge ?? this.isBlueBadge,
      isPinkBadge: isPinkBadge ?? this.isPinkBadge,
      socialLinks: socialLinks ?? this.socialLinks,
      numberOfFollowed: numberOfFollowed ?? this.numberOfFollowed,
      followingChannels: followingChannels ?? this.followingChannels,
      numberOfFollowers: numberOfFollowers ?? this.numberOfFollowers
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
      numberOfFollowed:
          json['numberOfFollowed'] is int? ? json['numberOfFollowed'] : 0,
      followingChannels: (json['followingChannels'] as List<dynamic>?)
          ?.map((e) => FollowingChannelModel.fromJson(e))
          .toList(),
      numberOfFollowers:
      json['numberOfFollowers'] is String? ? json['numberOfFollowers'] : '',
    );
  }
}
