import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:move_app/config/app_config_loading.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'config/app_config.dart';

void main() async {
  await AppConfig.init();
  runApp(const MyApp());
  AppConfigLoading.configLoading();
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      builder: (context, child) {
        return FlutterEasyLoading(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
              devicePixelRatio: 1.0,
            ),
            child: child!,
          ),
        );
      },
      initialRoute: AppRoutes.getInitialRoute(),
      routes: AppRoutes.getRoutes(),
    );
  }
}
