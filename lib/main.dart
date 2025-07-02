import 'package:milkfishfreshness_app/utils/ml_helper.dart';
import 'package:flutter/material.dart';
import 'screens/SplashScreen.dart';
import 'screens/HomePage.dart';
import 'screens/DeteksiPage.dart';
import 'screens/PanduanPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MLHelper.initialize();  // Load model sebelum runApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/deteksi': (context) => const DeteksiPage(),
        '/panduan': (context) => const PanduanPage(),
      },
    );
  }
}