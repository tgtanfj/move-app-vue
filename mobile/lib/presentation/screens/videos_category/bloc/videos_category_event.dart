sealed class VideosCategoryEvent {
  const VideosCategoryEvent();
}

final class VideosCategoryInitialEvent extends VideosCategoryEvent {
  final int categoryId;
  const VideosCategoryInitialEvent(this.categoryId);
}

final class VideosCategoryLoadMoreEvent extends VideosCategoryEvent {
  const VideosCategoryLoadMoreEvent();
}
