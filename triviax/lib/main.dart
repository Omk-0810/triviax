import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'app/theme/app_theme.dart';
import 'config/app_routes.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TriviaXApp(),
    ),
  );
}

class TriviaXApp extends StatelessWidget {
  const TriviaXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TriviaX',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
