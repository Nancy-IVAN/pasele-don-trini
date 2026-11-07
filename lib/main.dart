import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAM09by7Wf6-GHTfbPA_rAQ5tpg6rvk5FY",
        appId: "1:26644942666:web:dbca99688be44a6d16bbb3",
        messagingSenderId: "26644942666",
        projectId: "pasele-trini-app",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const PaseleTriniApp());
}

class PaseleTriniApp extends StatelessWidget {
  const PaseleTriniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurante Pásele D. Trini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}