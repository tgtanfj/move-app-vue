class ChannelVideoModel {
  final int? id;
  final String? name;
  final String? image;
  final bool? isBlueBadge;
  final bool? isPinkBadge;
  final int? numberOfFollowed;

  ChannelVideoModel({
    this.id,
    this.name,
    this.image,
    this.isBlueBadge,
    this.isPinkBadge,
    this.numberOfFollowed,
  });

  ChannelVideoModel copyWith({
    int? id,
    String? name,
    String? image,
    bool? isBlueBadge,
    bool? isPinkBadge,
    int? numberOfFollowed,
    bool? isFollowed,
  }) {
    return ChannelVideoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isBlueBadge: isBlueBadge ?? this.isBlueBadge,
      isPinkBadge: isPinkBadge ?? this.isPinkBadge,
      numberOfFollowed: numberOfFollowed ?? this.numberOfFollowed,
    );
  }

  factory ChannelVideoModel.fromJson(Map<String, dynamic> json) =>
      ChannelVideoModel(
        id: json['id'] != null ? json['id'] as int : 0,
        name: json['name'] != null ? json['name'] as String : '',
        image: json['image'] != null ? json['image'] as String : '',
        isBlueBadge:
            json['isBlueBadge'] != null ? json['isBlueBadge'] as bool : false,
        isPinkBadge:
            json['isPinkBadge'] != null ? json['isPinkBadge'] as bool : false,
        numberOfFollowed: json['numberOfFollowed'] != null
            ? json['numberOfFollowed'] as int
            : 0,
      );
}
