import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/aeconnect_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/shell/main_shell_screen.dart';

class AecApp extends StatelessWidget {
  const AecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AEConnectProvider(),
      child: Consumer<AEConnectProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'AE Connect',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: provider.isAuthenticated ? const MainShellScreen() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
