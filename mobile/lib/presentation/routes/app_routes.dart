import 'package:flutter/material.dart';
import 'package:move_app/presentation/screens/home/page/home_page.dart';
import 'package:move_app/presentation/screens/menu/page/menu_page.dart';
import 'package:move_app/presentation/screens/setting/page/setting_page.dart';

class AppRoutes {
  static const String routeProfile = '/profile';
  static const String routeMenu = '/menu';
  static const String logIn = '/login';
  static getInitialRoute() {
    return '/';
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      routeProfile: (BuildContext context) =>
          const SettingPage(),
      '/': (BuildContext context) => const HomePage(),
      routeMenu : (BuildContext context) =>
          const MenuPage(),
      //logIn : (BuildContext context) => const (),
    };
  }
}
