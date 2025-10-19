import 'package:flutter/material.dart';
import 'package:neos_coder/core/network/global_connectivity.dart';
import 'package:neos_coder/presentation/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';
import 'core/di/locator.dart';
import 'presentation/providers/task_list_provider.dart';
import 'presentation/providers/task_detail_provider.dart';
import 'presentation/routes/app_routes.dart';
import 'services/auth_service.dart';
final RouteObserver<PageRoute> appRouteObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConnectivity.globalConnectivity.init();
  await setupLocator();
  runApp(FieldTaskApp());
}

class FieldTaskApp extends StatelessWidget {
  const FieldTaskApp({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF4F46E5),
      scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(height: 1.3),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..bootstrap()),
        ChangeNotifierProvider(create: (_) => TaskListProvider()),
        ChangeNotifierProvider(create: (_) => TaskDetailProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        title: 'Field Task',
        theme: theme,
        onGenerateRoute: AppRoutes.onGenerate,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        navigatorObservers: [appRouteObserver],
        builder: (context, child) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: GlobalConnectivity.globalConnectivity.online,
                    builder: (_, online, __) {
                      if (online) return const SizedBox.shrink();
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: Colors.red.withValues(alpha: .12),
                        child: const Text(
                          'Internet connection not available',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      );
                    },
                  ),
                  Expanded(child: child ?? const SizedBox.shrink()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
