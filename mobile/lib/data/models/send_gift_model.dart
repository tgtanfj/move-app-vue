class SendGiftModel {
  int giftId;
  int videoId;
  String content;

  SendGiftModel({
    required this.giftId,
    required this.videoId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'giftPackageId': giftId,
      'videoId': videoId,
      'content': content,
    };
  }
}