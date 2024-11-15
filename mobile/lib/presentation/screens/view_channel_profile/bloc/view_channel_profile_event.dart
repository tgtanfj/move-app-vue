
sealed class ViewChannelProfileEvent {
  const ViewChannelProfileEvent();
}

final class ViewChannelProfileInitialEvent extends ViewChannelProfileEvent {
  final int idChannel;

  const ViewChannelProfileInitialEvent({required this.idChannel});
}

final class ViewChannelProfileFollowingItemSelectEvent
    extends ViewChannelProfileEvent {
  final int followingItemId;

  const ViewChannelProfileFollowingItemSelectEvent(this.followingItemId);
}

final class ViewChannelProfileFollowChannelEvent
    extends ViewChannelProfileEvent {
  final int channelId;

  const ViewChannelProfileFollowChannelEvent(this.channelId);
}
