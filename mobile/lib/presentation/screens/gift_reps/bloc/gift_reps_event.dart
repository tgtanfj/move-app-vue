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

final class GiftRepsSelectedTitleEvent extends GiftRepsEvent {
  final int titleId;
  const GiftRepsSelectedTitleEvent(this.titleId);
}

final class GiftRepsSendGiftEvent extends GiftRepsEvent {
  const GiftRepsSendGiftEvent();
}
