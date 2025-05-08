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

class NavigationBloc extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void navigateTo(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RFID Asset Management')),
      body: Center(
        child: Text('เริ่มต้นใช้งานแอพพลิเคชัน RFID Asset Management'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: Provider.of<NavigationBloc>(context).currentIndex,
        onTap:
            (index) => Provider.of<NavigationBloc>(
              context,
              listen: false,
            ).navigateTo(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'แดชบอร์ด',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.nfc), label: 'สแกน RFID'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'สินทรัพย์',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_export),
            label: 'ส่งออก',
          ),
        ],
      ),
    );
  }
}
