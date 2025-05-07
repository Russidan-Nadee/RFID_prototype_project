import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/configuration/app_config.dart';
import 'core/di/dependency_injection.dart';
import 'core/navigation/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/assets/bloc/asset_bloc.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/export/bloc/export_bloc.dart';
import 'features/main/bloc/navigation_bloc.dart';
import 'features/rfid/bloc/rfid_bloc.dart';
import 'features/search/bloc/search_bloc.dart';

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
