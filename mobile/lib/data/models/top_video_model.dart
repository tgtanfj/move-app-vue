
class TopVideoModel {
  final int? id;
  final String? thumbnailURL;
  final int? numberOfViews;
  final String? title;
  final String? workoutLevel;
  final String? duration;
  final DateTime? createdAt;
  final String? url;
  final String? urlS3;
  final int? durationsVideo;

  TopVideoModel({
    this.id,
    this.title,
    this.workoutLevel,
    this.duration,
    this.url,
    this.numberOfViews,
    this.urlS3,
    this.thumbnailURL,
    this.durationsVideo,
    this.createdAt,
  });

  TopVideoModel copyWith({
    int? id,
    String? title,
    String? workoutLevel,
    String? duration,
    String? url,
    int? numberOfViews,
    String? urlS3,
    String? thumbnailURL,
    int? durationsVideo,
    DateTime? createdAt,
    int? videoLength,
  }) {
    return TopVideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      workoutLevel: workoutLevel ?? this.workoutLevel,
      duration: duration ?? this.duration,
      url: url ?? this.url,
      numberOfViews: numberOfViews ?? this.numberOfViews,
      urlS3: urlS3 ?? this.urlS3,
      thumbnailURL: thumbnailURL ?? this.thumbnailURL,
      durationsVideo: durationsVideo ?? this.durationsVideo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TopVideoModel.fromJson(Map<String, dynamic> json) {
    return TopVideoModel(
      id: (json['id'] is int) ? json['id'] : 0,
      title: (json['title'] is String) ? json['title'] : '',
      workoutLevel:
      (json['workoutLevel'] is String) ? json['workoutLevel'] : '',
      duration: (json['duration'] is String) ? json['duration'] : '',
      url: (json['url'] is String) ? json['url'] : '',
      numberOfViews:
      (json['numberOfViews'] is num) ? json['numberOfViews'].toInt() : 0,
      urlS3: (json['urlS3'] is String) ? json['urlS3'] : '',
      thumbnailURL:
      (json['thumbnailURL'] is String) ? json['thumbnailURL'] : '',
      durationsVideo:
      (json['durationsVideo'] is num) ? json['durationsVideo'].toInt() : 0,
      createdAt: (json['createdAt'] is String)
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
