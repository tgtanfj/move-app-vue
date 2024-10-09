import 'package:flutter_easyloading/flutter_easyloading.dart';

class AppConfigLoading {
  static configLoading() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..dismissOnTap = false
      ..userInteractions =false
      ..maskType = EasyLoadingMaskType.black;
  }
}
