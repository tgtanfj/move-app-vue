class ViewVideoModel {
  int? videoId;
  String? date;
  int? viewTime;
  ViewVideoModel({
    this.videoId,
    this.date,
    this.viewTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'date': date,
      'viewTime': viewTime,
    };
  }
}
