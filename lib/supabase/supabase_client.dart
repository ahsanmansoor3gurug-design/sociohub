import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSafeClient {
  // Private constructor
  SupabaseSafeClient._internal();

  // The singleton instance
  static final SupabaseSafeClient _instance = SupabaseSafeClient._internal();

  // Factory constructor to return the same instance
  factory SupabaseSafeClient() => _instance;

  // Safe getter for the SupabaseClient
  SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      // Returns null if Supabase is not initialized (e.g., in Demo Mode)
      return null;
    }
  }
}
