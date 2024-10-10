class FollowingChannelModel {
  final int? id;
  final String? name;
  final String? image;
  final bool? isBlueBadge;
  final bool? isPinkBadge;
  final int? numberOfFollowers;

  FollowingChannelModel({
    this.id,
    this.name,
    this.image,
    this.isBlueBadge,
    this.isPinkBadge,
    this.numberOfFollowers,
  });

  FollowingChannelModel copyWith({
    int? id,
    String? name,
    String? image,
    bool? isBlueBadge,
    bool? isPinkBadge,
    int? numberOfFollowers,
  }) {
    return FollowingChannelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isBlueBadge: isBlueBadge ?? this.isBlueBadge,
      isPinkBadge: isPinkBadge ?? this.isPinkBadge,
    );
  }

  factory FollowingChannelModel.fromJson(Map<String, dynamic> json) {
    return FollowingChannelModel(
      id: json['id'] is int? ? json['id'] : 0,
      name: json['name'] is String? ? json['name'] : '',
      image: json['image'] is String? ? json['image'] : '',
      isBlueBadge: json['isBlueBadge'] is bool ? json['isBlueBadge'] : false,
      isPinkBadge: json['isPinkBadge'] is bool ? json['isPinkBadge'] : false,
    );
  }
}
