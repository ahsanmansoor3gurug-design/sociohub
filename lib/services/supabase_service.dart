import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/city_model.dart';
import '../models/society_model.dart';
import '../utils/constants.dart';
import '../supabase/supabase_initializer.dart';
import '../supabase/supabase_client.dart';

class SupabaseService {
  // Singleton pattern for the service itself
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Use the singleton client
  SupabaseClient? get _client => SupabaseSafeClient().client;

  // Use the flag from SupabaseInitializer
  bool get isDemoMode => SupabaseInitializer.isDemoMode;

  // --- Mock Data ---
  final List<City> _mockCities = [
    City(id: '1', name: 'Karachi'),
    City(id: '2', name: 'Lahore'),
    City(id: '3', name: 'Islamabad'),
  ];

  final List<Society> _mockSocieties = [
    Society(
      id: 's1',
      cityId: '1',
      name: 'DHA Phase 6',
      area: 'Clifton',
      createdBy: 'demo-user',
      status: AppConstants.STATUS_APPROVED,
      createdAt: DateTime.now(),
    ),
    Society(
      id: 's2',
      cityId: '1',
      name: 'Bahria Town',
      area: 'Super Highway',
      createdBy: 'demo-user',
      status: AppConstants.STATUS_APPROVED,
      createdAt: DateTime.now(),
    ),
  ];

  // --- City Operations ---
  Future<List<City>> getCities() async {
    if (isDemoMode || _client == null) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulating network
      return _mockCities;
    }

    try {
      final response = await _client!
          .from('cities')
          .select()
          .order('name', ascending: true);
      return (response as List).map((json) => City.fromJson(json)).toList();
    } catch (e) {
      return _mockCities; // Fallback
    }
  }

  // --- Society Operations ---
  Future<List<Society>> getSocieties(String cityId) async {
    if (isDemoMode || _client == null) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockSocieties.where((s) => s.cityId == cityId).toList();
    }

    try {
      final response = await _client!
          .from('societies')
          .select()
          .eq('city_id', cityId)
          .eq('status', AppConstants.STATUS_APPROVED);
      return (response as List).map((json) => Society.fromJson(json)).toList();
    } catch (e) {
      return _mockSocieties.where((s) => s.cityId == cityId).toList();
    }
  }

  Future<bool> addSociety(Society society) async {
    if (isDemoMode || _client == null) return true;

    try {
      await _client!.from('societies').insert(society.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
