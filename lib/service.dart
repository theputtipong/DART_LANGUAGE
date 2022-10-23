// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';

enum PlatformScreen { isMobile, isTablet, isLaptop, isDesktop }

checkScreen(BuildContext context, {required int function}) {
  double width = MediaQuery.of(context).size.width;
  int expanded = 0;
  if (width < 450) {
    print('checkScreen: $width platformScreen: ${PlatformScreen.isMobile}');
    expanded = 2;
  } else if (width < 900) {
    print('checkScreen: $width platformScreen: ${PlatformScreen.isTablet}');
    expanded = 3;
  } else if (width > 900 && width < 1300) {
    print('checkScreen: $width platformScreen: ${PlatformScreen.isLaptop}');
    expanded = 4;
  } else {
    print('checkScreen: $width platformScreen: ${PlatformScreen.isDesktop}');
    expanded = 5;
  }
  switch (function) {
    case 0: // return number expanded
      return expanded;
    default:
      return const SizedBox();
  }
}
