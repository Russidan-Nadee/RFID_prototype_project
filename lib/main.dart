import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/dependency_injection.dart';
import 'features/rfid/bloc/rfid_bloc.dart';
import 'features/search/bloc/search_bloc.dart';
import 'shared/utils/theme_utils.dart';

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
          create: (_) => RfidBloc(DependencyInjection.get()),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchBloc(DependencyInjection.get()),
        ),
      ],
      child: MaterialApp(
        title: 'RFID Asset Management',
        theme: ThemeUtils.getLightTheme(),
        darkTheme: ThemeUtils.getDarkTheme(),
        themeMode: ThemeMode.system,
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
// class MyApp extends StatelessWidget 