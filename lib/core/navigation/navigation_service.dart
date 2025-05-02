import 'package:flutter/material.dart';
import '../constants/navigation_constants.dart';

class NavigationService {
  /// Navigate to a tab by index from bottom navigation
  static void navigateToTabByIndex(BuildContext context, int index) {
    if (index < 0 || index >= NavigationConstants.tabRoutes.length) return;

    final route = NavigationConstants.tabRoutes[index];
    Navigator.pushNamed(context, route);
  }

  /// Navigate to a specific route
  static void navigateToRoute(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  /// Replace current screen with another route
  static void replaceWithRoute(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  /// Navigate to home screen and clear navigation history
  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      NavigationConstants.tabRoutes[0],
      (route) => false,
    );
  }
}
