import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;

  const AppScaffold({
    Key? key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // สร้าง AppBar ใหม่ที่ไม่มีปุ่มย้อนกลับเสมอ (ถ้ามี appBar)
    final modifiedAppBar =
        appBar != null ? _createAppBarWithoutBackButton(appBar!) : null;

    return Scaffold(
      appBar: modifiedAppBar,
      body: SafeArea(child: child),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor ?? Colors.white,
    );
  }

  // สร้าง AppBar ใหม่โดยไม่มีปุ่มย้อนกลับในทุกหน้า
  PreferredSizeWidget _createAppBarWithoutBackButton(
    PreferredSizeWidget originalAppBar,
  ) {
    if (originalAppBar is AppBar) {
      return AppBar(
        automaticallyImplyLeading: false, // ปิดการแสดงปุ่มย้อนกลับในทุกหน้า
        title: originalAppBar.title,
        actions: originalAppBar.actions,
        backgroundColor: originalAppBar.backgroundColor,
        elevation: originalAppBar.elevation,
        centerTitle: originalAppBar.centerTitle,
        bottom: originalAppBar.bottom,
      );
    }
    return originalAppBar;
  }
}
