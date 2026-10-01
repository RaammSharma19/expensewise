import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expensewise/core/theme/app_theme.dart';
import 'package:expensewise/core/database/database.dart';
import 'package:expensewise/core/di/service_locator.dart';
import 'package:expensewise/core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final database = AppDatabase();
  await database.initialize();
  
  // Setup service locator
  setupServiceLocator(database);
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'ExpenseWise',
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
