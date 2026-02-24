import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/save_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SaveService.instance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.primaryDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const OscarGamesApp());
}

class OscarGamesApp extends StatelessWidget {
  const OscarGamesApp({super.key});

  static const double maxAppWidth = 500;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSCAR Games',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return Container(
          color: const Color(0xFF050A14),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxAppWidth),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryDark,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.08),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          ),
        );
      },
      home: const HomeScreen(),
    );
  }
}
