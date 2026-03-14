import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../supabase/services/supabase_service.dart';
import 'society_screen.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<City> cities = [];
  List<City> filteredCities = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    setState(() => isLoading = true);
    final fetchedCities = await _supabaseService.getCities();
    setState(() {
      cities = fetchedCities;
      filteredCities = fetchedCities;
      isLoading = false;
    });
  }

  void filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCities = cities;
      } else {
        filteredCities = cities
            .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your City"),
        elevation: 0,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: filterCities,
              decoration: InputDecoration(
                hintText: "Search city...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredCities.isEmpty
                    ? Center(
                        child: Text("No city found"),
                      )
                    : ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          final city = filteredCities[index];
                          return ListTile(
                            leading: Icon(Icons.location_city, color: Colors.green),
                            title: Text(city.name),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SocietyScreen(
                                    cityId: city.id,
                                    cityName: city.name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
