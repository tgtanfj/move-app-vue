import 'dart:async';

import 'package:flutter/material.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/create_new_password/page/create_new_password_page.dart';
import 'package:uni_links2/uni_links.dart';

import 'config/app_config.dart';

void main() async {
  await AppConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<String?>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initDeepLink();
  }

  Future<void> _initDeepLink() async {
    try {
      final initialLink = await getInitialLink();
      _handleDeepLink(initialLink);
    } catch (e) {
      print('Failed to get initial link: $e');
    }

    _linkSubscription = linkStream.listen((String? link) {
      _handleDeepLink(link);
    }, onError: (err) {
      print('Failed to get link: $err');
    });
  }

  void _handleDeepLink(String? link) {
    if (link != null && link.contains('reset-password')) {
      final token = link.split('/').last;
      navigatorKey.currentState?.push(
        MaterialPageRoute(
            builder: (context) => CreateNewPasswordPage(token: token)),
      );
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
            devicePixelRatio: 1.0,
          ),
          child: child!,
        );
      },
      initialRoute: AppRoutes.getInitialRoute(),
      routes: AppRoutes.getRoutes(),
    );
  }
}
