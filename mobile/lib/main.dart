import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:move_app/config/app_config_loading.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/create_new_password/page/create_new_password_page.dart';

import '.env.dart';
import 'config/app_config.dart';

void main() async {
  await AppConfig.init();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
  AppConfigLoading.configLoading();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri?>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _initDeepLink();
  }

  Future<void> _initDeepLink() async {
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? link) {
      _handleDeepLink(link);
    }, onError: (err) {
      if (kDebugMode) {
        print('Failed to get link: $err');
      }
    });
  }

  void _handleDeepLink(Uri? uri) {
    if (uri != null && uri.host == 'reset-password') {
      final token = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

      if (token != null && token.isNotEmpty) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordPage(token: token),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Token is missing or empty.');
        }
      }
    } else {
      if (kDebugMode) {
        print('Invalid deep link or host.');
      }
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
        final width = MediaQuery.of(context).size.width;
        double textScaleFactor;
        if (width < 400) {
          textScaleFactor = 0.8;
        } else {
          textScaleFactor = 1.0;
        }
        return FlutterEasyLoading(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScaleFactor),
              devicePixelRatio: 1.0,
            ),
            child: child!,
          ),
        );
      },
      initialRoute: AppRoutes.getInitialRoute(),
      routes: AppRoutes.getRoutes(),
      // home: const WalletPage(),
    );
  }
}
