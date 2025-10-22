import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:presum/ui/splash_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "API_KEY", 
      appId: "APP_ID", 
      messagingSenderId: "MESSAGING_SENDER_ID",  
      projectId: "PROJECT_ID", 
      storageBucket: "STORAGE_BUCKET",
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "OpenSans",
      ),
      home: const SplashScreen(),
    );
  }
}