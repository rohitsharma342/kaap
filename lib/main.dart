import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'controllers/profile_controller.dart';
import 'controllers/video_controller.dart';
import 'utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => VideoController()),
      ],
      child: MaterialApp(
        title: 'KAAP',
        theme: ThemeData(
          primaryColor: AppConstants.primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: AppConstants.primaryColor,
            elevation: 0,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: AppConstants.primaryColor,
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}