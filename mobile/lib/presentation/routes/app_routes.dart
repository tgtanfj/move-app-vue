import 'package:flutter/material.dart';
import 'package:move_app/presentation/screens/category/page/category_page.dart';
import 'package:move_app/presentation/screens/create_new_password/page/create_new_password_page.dart';
import 'package:move_app/presentation/screens/forgot_password/page/forgot_password/forgot_password_page.dart';
import 'package:move_app/presentation/screens/home/page/home_page.dart';
import 'package:move_app/presentation/screens/menu/page/menu_page.dart';
import 'package:move_app/presentation/screens/setting/page/setting_page.dart';
import 'package:move_app/presentation/screens/videos_category/page/videos_category_page.dart';
import 'package:move_app/presentation/screens/view_FAQs/page/view_FAQs_page.dart';

class AppRoutes {
  static const String routeProfile = '/profile';
  static const String routeMenu = '/menu';
  static const String logIn = '/login';
  static const String routeviewFAQs = '/view-FAQs';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeCreateNewPassword = '/create-new-password';
  static const String home = '/home';
  static const String routeCategory = '/category';
  static const String routeSearch = '/search';
  static const String routeCategoryResult = '/category-result';

  static getInitialRoute() {
    return '/';
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      routeProfile: (BuildContext context) => const SettingPage(),
      '/': (BuildContext context) => const HomePage(),
      home: (BuildContext context) => const HomePage(),
      routeMenu: (BuildContext context) => const MenuPage(),
      routeviewFAQs: (BuildContext context) => const ViewFAQsPage(),
      routeForgotPassword: (BuildContext context) => const ForgotPasswordPage(),
      routeCreateNewPassword: (BuildContext context) =>
          const CreateNewPasswordPage(),
      routeCategory: (BuildContext context) => const CategoryPage(),
    };
  }
}
