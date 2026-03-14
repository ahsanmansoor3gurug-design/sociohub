import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/city_model.dart';
import '../../models/society_model.dart';
import '../../utils/constants.dart';
import '../supabase_client.dart';
import '../supabase_initializer.dart';
import '../../services/local_db_service.dart';

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
    // 1. Try Online
    if (!isDemoMode && _client != null) {
      try {
        final response = await _client!
            .from('cities')
            .select()
            .order('name', ascending: true);
        
        final cities = (response as List).map((json) => City.fromJson(json)).toList();
        
        // Save to Local DB for offline use
        await LocalDatabaseService.instance.saveCities(cities);
        return cities;
      } catch (e) {
        print("Online fetch failed, trying local storage...");
      }
    }

    // 2. Try Local SQLite
    final localCities = await LocalDatabaseService.instance.getCities();
    if (localCities.isNotEmpty) return localCities;

    // 3. Last Resort: Mock Data
    return _mockCities;
  }

  // --- Society Operations ---
  Future<List<Society>> getSocieties(String cityId) async {
    // 1. Try Online
    if (!isDemoMode && _client != null) {
      try {
        final response = await _client!
            .from('societies')
            .select()
            .eq('city_id', cityId)
            .eq('status', AppConstants.STATUS_APPROVED);
        
        final societies = (response as List).map((json) => Society.fromJson(json)).toList();
        
        // Save to Local DB for offline use
        await LocalDatabaseService.instance.saveSocieties(societies);
        return societies;
      } catch (e) {
        print("Online fetch failed, trying local storage...");
      }
    }

    // 2. Try Local SQLite
    final localSocieties = await LocalDatabaseService.instance.getSocieties(cityId);
    if (localSocieties.isNotEmpty) return localSocieties;

    // 3. Last Resort: Mock Data
    return _mockSocieties.where((s) => s.cityId == cityId).toList();
  }

  Future<bool> addSociety(Society society) async {
    if (isDemoMode || _client == null) return true;

    try {
      await _client!.from('societies').insert(society.toJson());
      // Also save locally immediately
      await LocalDatabaseService.instance.saveSocieties([society]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
