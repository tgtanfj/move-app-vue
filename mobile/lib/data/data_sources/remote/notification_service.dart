import 'package:firebase_database/firebase_database.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/data/models/notification_model.dart';

class NotificationService {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL: ApiUrls.realTimeDatabaseUrl,
  ).ref();

  Stream<int> listenForUnreadCount(int userId) {
    final ref = _database.child('notifications/$userId');

    return ref.onValue.map((event) {
      if (!event.snapshot.exists) return 0;

      final notifications = Map<dynamic, dynamic>.from(
        event.snapshot.value as Map,
      );

      return notifications.values
          .where((notif) => notif['isRead'] == false)
          .length;
    });
  }

  Stream<NotificationModel> listenForNewNotifications(int userId) {
    final ref = _database.child('notifications/$userId');

    return ref
        .orderByChild('timestamp')
        .startAfter(DateTime.now().millisecondsSinceEpoch)
        .onChildAdded
        .map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return NotificationModel.fromJson(data, event.snapshot.key!);
    });
  }

  Future<List<NotificationModel>> getLatestUserNotifications(
      int userId,
      int limit, {
        int? lastTimestamp,
      }) async {
    final ref = _database.child('notifications/$userId');

    Query query = ref.orderByChild('timestamp').limitToLast(limit);
    if (lastTimestamp != null) {
      query = query.endAt(lastTimestamp - 1);
    }

    try {
      final snapshot = await query.get();
      if (!snapshot.exists) return [];

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);
      final notifications = data.entries.map((entry) {
        final notificationData = Map<String, dynamic>.from(entry.value);
        return NotificationModel.fromJson(notificationData, entry.key);
      }).toList();

      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return notifications;
    } catch (e) {
      return [];
    }
  }

  Future<List<NotificationModel>> loadMoreNotifications(
      int userId,
      int limit,
      int lastTimestamp,
      ) async {
    return getLatestUserNotifications(userId, limit, lastTimestamp: lastTimestamp);
  }

  Future<bool> markNotificationAsRead(int userId, String notificationKey) async {
    final ref = _database
        .child('notifications/$userId/$notificationKey/isRead');

    try {
      await ref.set(true);

      final snapshot = await ref.get();
      return snapshot.exists && snapshot.value == true;
    } catch (e) {
      return false;
    }
  }
}
