class ViewChannelProfileInitialEvent extends ViewChannelProfileEvent {}

class FetchViewChannelProfileEvent extends ViewChannelProfileEvent {}

sealed class ViewChannelProfileEvent {
  const ViewChannelProfileEvent();
}

final class ViewChannelProfileFollowingItemSelectEvent
    extends ViewChannelProfileEvent {
  final int followingItemId;

  const ViewChannelProfileFollowingItemSelectEvent(this.followingItemId);
}
