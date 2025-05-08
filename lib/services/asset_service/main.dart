import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfid_project/core/configuration/app_config.dart';
import 'package:rfid_project/core/di/dependency_injection.dart';
import 'package:rfid_project/shared/utils/theme_utils.dart';
import 'package:rfid_project/features/rfid/bloc/rfid_bloc.dart';
import 'package:rfid_project/features/search/bloc/search_bloc.dart';
import 'package:rfid_project/waitforedit/corewait/navigation/app_routes.dart';
import 'package:rfid_project/waitforedit/presentation/features/assets/blocs/asset_bloc.dart';
import 'package:rfid_project/waitforedit/presentation/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:rfid_project/waitforedit/presentation/features/export/blocs/export_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // เริ่มต้น Dependency Injection
  await DependencyInjection.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationBloc()),
        ChangeNotifierProvider(
          create: (_) => AssetBloc(DependencyInjection.get()),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardBloc(DependencyInjection.get()),
        ),
        ChangeNotifierProvider(
          create: (_) => ExportBloc(DependencyInjection.get()),
        ),
        ChangeNotifierProvider(
          create: (_) => RfidBloc(DependencyInjection.get()),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchBloc(DependencyInjection.get()),
        ),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: ThemeUtils.getLightTheme(),
        darkTheme: ThemeUtils.getDarkTheme(),
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// สร้าง NavigationBloc ชั่วคราวเพื่อให้โค้ดทำงานได้
class NavigationBloc extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void navigateTo(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
