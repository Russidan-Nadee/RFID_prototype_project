import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double iconSize;
  final double elevation;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.iconSize = 24.0,
    this.elevation = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: selectedItemColor ?? Theme.of(context).primaryColor,
      unselectedItemColor: unselectedItemColor ?? Colors.grey,
      iconSize: iconSize,
      elevation: elevation,
      showUnselectedLabels: true,
    );
  }
}
