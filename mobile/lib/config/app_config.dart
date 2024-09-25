import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:move_app/config/firebase_options.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';

class AppConfig {
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await SharedPrefer().init();
  }
}
