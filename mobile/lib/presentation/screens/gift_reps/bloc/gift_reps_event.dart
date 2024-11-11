sealed class GiftRepsEvent {
  const GiftRepsEvent();
}

final class GiftRepsInitialEvent extends GiftRepsEvent {
  final int? videoId;
  const GiftRepsInitialEvent(this.videoId);
}

final class GiftRepsSelectedGiftEvent extends GiftRepsEvent {
  final int giftId;
  const GiftRepsSelectedGiftEvent(this.giftId);
}

final class GiftRepsOnChangeTitleEvent extends GiftRepsEvent {
  final String title;
  const GiftRepsOnChangeTitleEvent(this.title);
}

final class GiftRepsSendGiftEvent extends GiftRepsEvent {
  const GiftRepsSendGiftEvent();
}
