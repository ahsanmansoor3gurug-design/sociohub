import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant_model.dart';
import '../services/local_db_service.dart';
import '../ads/banner_ad_widget.dart';

class RestaurantDirectoryScreen extends StatefulWidget {
  final String societyId;
  final String societyName;

  const RestaurantDirectoryScreen({
    super.key,
    required this.societyId,
    required this.societyName,
  });

  @override
  State<RestaurantDirectoryScreen> createState() => _RestaurantDirectoryScreenState();
}

class _RestaurantDirectoryScreenState extends State<RestaurantDirectoryScreen> {
  List<Restaurant> _restaurants = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Fast Food', 'Desi', 'Chinese', 'Bakery'];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    setState(() => _isLoading = true);
    
    // 1. Load from Local SQLite
    final local = await LocalDatabaseService.instance.getRestaurants(widget.societyId);
    if (local.isNotEmpty) {
      setState(() {
        _restaurants = local;
        _isLoading = false;
      });
    }

    // 2. Fetch Fresh Data (Mocking B-17 specific restaurants)
    final fresh = await _fetchRestaurants();
    if (mounted) {
      setState(() {
        _restaurants = fresh;
        _isLoading = false;
      });
    }
  }

  Future<List<Restaurant>> _fetchRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));
    // Real MPCHS B-17 Restaurant Mock Data
    final mock = [
      Restaurant(id: 'r1', societyId: widget.societyId, name: 'Savour Foods', cuisine: 'Desi', phoneNumber: '051111728687', address: 'Block C, B-17', rating: 4.5),
      Restaurant(id: 'r2', societyId: widget.societyId, name: 'Cheezious', cuisine: 'Fast Food', phoneNumber: '051111446699', address: 'Block B, B-17', rating: 4.8),
      Restaurant(id: 'r3', societyId: widget.societyId, name: 'Tehzeeb Bakery', cuisine: 'Bakery', phoneNumber: '0512724422', address: 'Block A, B-17', rating: 4.7),
      Restaurant(id: 'r4', societyId: widget.societyId, name: 'Hot n Spicy', cuisine: 'Desi', phoneNumber: '03001234567', address: 'Block G, B-17', rating: 4.2),
      Restaurant(id: 'r5', societyId: widget.societyId, name: 'Pizza Hut', cuisine: 'Fast Food', phoneNumber: '051111241241', address: 'Block B, B-17', rating: 4.0),
    ];
    
    await LocalDatabaseService.instance.saveRestaurants(mock);
    return mock;
  }

  Future<void> _makeCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  List<Restaurant> get _filteredRestaurants {
    if (_selectedCategory == 'All') return _restaurants;
    return _restaurants.where((r) => r.cuisine == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food in ${widget.societyName}'),
        backgroundColor: Colors.orange[800],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = cat);
                    },
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  ),
                );
              },
            ),
          ),
          
          Expanded(
            child: _isLoading && _restaurants.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final rest = _filteredRestaurants[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(rest.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${rest.cuisine} • ⭐ ${rest.rating}\n${rest.address}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delivery_dining, color: Colors.orange),
                            onPressed: () => _makeCall(rest.phoneNumber),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
