import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theming/app_breakpoints.dart';
import '../theming/app_sizes.dart';

enum DeviceLayout {
  phone,
  tablet,
  desktop,
}

class DeviceHelper {
  const DeviceHelper._();

  static Size sizeOf(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  static DeviceLayout layoutOf(BuildContext context) {
    final width = sizeOf(context).width;

    if (width >= AppBreakpoints.desktop) {
      return DeviceLayout.desktop;
    }
    if (width >= AppBreakpoints.tablet) {
      return DeviceLayout.tablet;
    }

    return DeviceLayout.phone;
  }

  static bool isPhone(BuildContext context) {
    return layoutOf(context) == DeviceLayout.phone;
  }

  static bool isTablet(BuildContext context) {
    return layoutOf(context) == DeviceLayout.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return layoutOf(context) == DeviceLayout.desktop;
  }

  static bool isWide(BuildContext context) {
    return sizeOf(context).width >= AppBreakpoints.tablet;
  }

  static double horizontalPadding(BuildContext context) {
    return switch (layoutOf(context)) {
      DeviceLayout.phone => AppSizes.lg,
      DeviceLayout.tablet => AppSizes.xxl,
      DeviceLayout.desktop => AppSizes.xxxl,
    };
  }

  static double maxContentWidth(BuildContext context) {
    return switch (layoutOf(context)) {
      DeviceLayout.phone => AppBreakpoints.phoneMaxContentWidth,
      DeviceLayout.tablet => AppBreakpoints.tabletMaxContentWidth,
      DeviceLayout.desktop => AppBreakpoints.desktopMaxContentWidth,
    };
  }

  static double onboardingImageHeight(double availableHeight) {
    return math.max(248, math.min(availableHeight * .54, 430));
  }

  static double authTopSpacing(BuildContext context) {
    final height = sizeOf(context).height;
    return math.max(AppSizes.xl, math.min(height * .12, 108));
  }

  static T value<T>({
    required BuildContext context,
    required T phone,
    T? tablet,
    T? desktop,
  }) {
    return switch (layoutOf(context)) {
      DeviceLayout.phone => phone,
      DeviceLayout.tablet => tablet ?? phone,
      DeviceLayout.desktop => desktop ?? tablet ?? phone,
    };
  }
}
