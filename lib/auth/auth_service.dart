import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_initializer.dart';
import '../supabase/supabase_client.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Use the singleton client
  SupabaseClient? get _client => SupabaseSafeClient().client;

  bool get isDemoMode => SupabaseInitializer.isDemoMode;

  User? get currentUser => isDemoMode ? null : _client?.auth.currentUser;

  Future<void> signUp(String email, String password) async {
    if (isDemoMode) return;
    await _client?.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse?> signIn(String email, String password) async {
    if (isDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      return null; 
    }
    return await _client?.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    if (isDemoMode) return;
    await _client?.auth.signOut();
  }
}
