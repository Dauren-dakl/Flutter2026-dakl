import 'package:flutter/material.dart';
import 'shell/shell.dart';
import 'routes/routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'models/item.dart';
import 'models/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Events',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark)),
      themeMode: ThemeMode.system,
      initialRoute: Routes.shell,
      routes: {
        Routes.shell: (_) => const Shell(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.detail) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => DetailScreen(
              item: args['item'] as Item,
              profile: args['profile'] as Profile,
            ),
          );
        }
        if (settings.name == Routes.form) {
          final item = settings.arguments as Item?;
          return MaterialPageRoute(
            builder: (_) => FormScreen(initialItem: item),
          );
        }
        return null;
      },
    );
  }
}