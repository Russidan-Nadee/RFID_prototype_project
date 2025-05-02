import 'package:flutter/material.dart';
import 'route_constants.dart';

class NavigationConstants {
  // Bottom navigation bar items
  static const List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),
    BottomNavigationBarItem(icon: Icon(Icons.visibility), label: 'View'),
    BottomNavigationBarItem(icon: Icon(Icons.file_download), label: 'Export'),
  ];

  // Tab routes - linked to each bottom navigation item
  static const List<String> tabRoutes = [
    RouteConstants.home,
    RouteConstants.searchAssets,
    RouteConstants.scanRfid,
    RouteConstants.viewAssets,
    RouteConstants.export,
  ];
}
