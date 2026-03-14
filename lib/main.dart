import 'package:flutter/material.dart';
import 'supabase/supabase_initializer.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase using the specialized initializer
  await SupabaseInitializer.initialize();

  runApp(const SocioHubApp());
}

class SocioHubApp extends StatelessWidget {
  const SocioHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SocioHub",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
