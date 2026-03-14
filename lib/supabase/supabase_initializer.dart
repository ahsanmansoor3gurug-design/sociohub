import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class SupabaseInitializer {
  static bool isDemoMode = true;

  static Future<void> initialize() async {
    try {
      const String url = SupabaseConfig.url;
      const String anonKey = SupabaseConfig.anonKey;

      if (url != 'https://your-project-id.supabase.co') {
        await Supabase.initialize(
          url: url,
          anonKey: anonKey,
        );
        isDemoMode = false;
        debugPrint("Supabase Initialized Successfully");
      } else {
        debugPrint("Using Demo Mode: Placeholder keys detected");
        isDemoMode = true;
      }
    } catch (e) {
      debugPrint("Using Demo Mode: Error during initialization: $e");
      isDemoMode = true;
    }
  }
}
