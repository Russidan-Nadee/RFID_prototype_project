import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfid_project/waitforedit/corewait/config/app_config.dart';
import 'package:rfid_project/waitforedit/corewait/di/dependency_injection.dart';
import 'package:rfid_project/waitforedit/corewait/navigation/app_routes.dart';
import 'package:rfid_project/waitforedit/corewait/theme/app_theme.dart';
import 'package:rfid_project/waitforedit/presentation/features/assets/blocs/asset_bloc.dart';
import 'package:rfid_project/waitforedit/presentation/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:rfid_project/waitforedit/presentation/features/export/blocs/export_bloc.dart';
import 'package:rfid_project/waitforedit/presentation/features/main/blocs/navigation_bloc.dart';

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
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
