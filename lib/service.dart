// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

enum Platform { isMobile, isTablet, isLaptop, isDesktop, isWeb, isOther }

checkScreen(BuildContext context, {required int function}) {
  double width = MediaQuery.of(context).size.width;
  int expanded = 0;
  if (width < 450) {
    print('checkScreen: $width platformScreen: ${Platform.isMobile}');
    expanded = 2;
  } else if (width < 900) {
    print('checkScreen: $width platformScreen: ${Platform.isTablet}');
    expanded = 3;
  } else if (width > 900 && width < 1300) {
    print('checkScreen: $width platformScreen: ${Platform.isLaptop}');
    expanded = 4;
  } else {
    print('checkScreen: $width platformScreen: ${Platform.isDesktop}');
    expanded = 5;
  }
  switch (function) {
    case 0: // return number expanded
      return expanded;
    default:
      return const SizedBox();
  }
}

checkPlatform() {
  if (kIsWeb) {
    print('checkPlatform: Platform running on web');
    return Platform.isWeb;
  } else {
    if (defaultTargetPlatform != TargetPlatform.android) {
      print('checkPlatform: Platform running on ${TargetPlatform.android}');
      return Platform.isMobile;
    } else if (defaultTargetPlatform != TargetPlatform.windows) {
      print('checkPlatform: Platform running on ${TargetPlatform.windows}');
      return Platform.isDesktop;
    } else {
      print('checkPlatform: Platform running on other target');
      return Platform.isOther;
    }
  }
}
