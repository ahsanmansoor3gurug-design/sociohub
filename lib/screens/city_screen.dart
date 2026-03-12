import 'package:flutter/material.dart';
import 'society_screen.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final List<String> cities = [
    "Karachi",
    "Lahore",
    "Islamabad",
    "Rawalpindi",
    "Hyderabad",
    "Faisalabad",
    "Multan",
    "Peshawar",
    "Quetta",
    "Sialkot",
  ];

  late List<String> filteredCities;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCities = cities;
  }

  void filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCities = cities;
      } else {
        filteredCities = cities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
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
            child: filteredCities.isEmpty
                ? Center(
                    child: Text("No city found"),
                  )
                : ListView.builder(
                    itemCount: filteredCities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.location_city, color: Colors.green),
                        title: Text(filteredCities[index]),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SocietyScreen(
                                cityName: filteredCities[index],
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

