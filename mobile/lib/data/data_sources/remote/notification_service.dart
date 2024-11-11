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

  bool _hasMoreNotifications = true;

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

    final sixMonthsAgo = DateTime.now()
        .subtract(const Duration(days: 180))
        .millisecondsSinceEpoch;

    try {
      final snapshot = await query.get();

      if (!snapshot.exists) {
        _hasMoreNotifications = false;
        return [];
      }

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);
      var notifications = data.entries.map((entry) {
        final notificationData = Map<String, dynamic>.from(entry.value);
        return NotificationModel.fromJson(notificationData, entry.key);
      }).toList();

      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notifications =
          notifications.where((n) => n.timestamp >= sixMonthsAgo).toList();

      if (notifications.length < limit) {
        _hasMoreNotifications = false;
      }

      return notifications;
    } catch (e) {
      _hasMoreNotifications = false;
      return [];
    }
  }

  Future<List<NotificationModel>> loadMoreNotifications(
    int userId,
    int limit,
    int lastTimestamp,
  ) async {
    if (!_hasMoreNotifications) {
      return [];
    }

    List<NotificationModel> notifications = await getLatestUserNotifications(
        userId, limit,
        lastTimestamp: lastTimestamp);

    if (notifications.isEmpty && notifications.length < limit) {
      _hasMoreNotifications = false;
    }

    return notifications;
  }

  Future<bool> markNotificationAsRead(
      int userId, String notificationKey) async {
    final ref =
        _database.child('notifications/$userId/$notificationKey/isRead');

    try {
      await ref.set(true);
      final snapshot = await ref.get();
      return snapshot.exists && snapshot.value == true;
    } catch (e) {
      return false;
    }
  }
}
