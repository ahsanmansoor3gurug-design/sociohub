import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ads/ad_service.dart';
import 'ads/app_open_ad_manager.dart';
import 'supabase/supabase_initializer.dart';
import 'screens/splash_screen.dart';

// Create a global instance of the App Open Ad Manager
late AppOpenAdManager appOpenAdManager;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load Environment Variables
  await dotenv.load(fileName: ".env");

  // Initialize Services
  await SupabaseInitializer.initialize();
  await AdService.initialize();
  
  // Initialize and load the first App Open Ad
  appOpenAdManager = AppOpenAdManager()..loadAd();

  runApp(const SocioHubApp());
}

class SocioHubApp extends StatefulWidget {
  const SocioHubApp({super.key});

  @override
  State<SocioHubApp> createState() => _SocioHubAppState();
}

class _SocioHubAppState extends State<SocioHubApp> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    // Start observing app lifecycle (background/foreground)
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the app comes to the foreground from background, show the ad!
    if (state == AppLifecycleState.resumed) {
      appOpenAdManager.showAdIfAvailable();
    }
  }

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
