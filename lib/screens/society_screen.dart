import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_society_screen.dart';

class SocietyScreen extends StatefulWidget {
  final String cityName;

  SocietyScreen({required this.cityName});

  @override
  _SocietyScreenState createState() => _SocietyScreenState();
}

class _SocietyScreenState extends State<SocietyScreen> {
  // Sample societies - In real app, this will come from Firebase
  final Map<String, List<String>> societiesByCity = {
    "Karachi": ["DHA Phase 6", "Bahria Town Karachi", "Gulshan-e-Iqbal", "North Nazimabad"],
    "Lahore": ["DHA Phase 5", "Bahria Town Lahore", "Garden Town", "Johar Town"],
    "Islamabad": ["F-7", "F-8", "E-7", "I-8"],
    "Rawalpindi": ["Pindi Bhattian", "Adiala Road", "Rawalpindi Cantonment"],
    "Hyderabad": ["Latifabad", "Gulistan-e-Johar", "Hyderabad Cantonment"],
    "Faisalabad": ["Millat Road", "Race Course Road", "Gulberg"],
    "Multan": ["Cantonment", "Nawab Pur Road"],
    "Peshawar": ["Peshawar Cantonment", "Hayatabad"],
    "Quetta": ["Quetta City", "Satellite Town"],
    "Sialkot": ["City Center", "New City"],
  };

  late List<String> societies;
  late List<String> filteredSocieties;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    societies = societiesByCity[widget.cityName] ?? [];
    filteredSocieties = societies;
  }

  void filterSocieties(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSocieties = societies;
      } else {
        filteredSocieties = societies
            .where((society) => society.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.cityName} - Societies"),
        elevation: 0,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: filterSocieties,
              decoration: InputDecoration(
                hintText: "Search society...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Societies List
          Expanded(
            child: filteredSocieties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No society found"),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredSocieties.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Icon(Icons.home, color: Colors.green),
                          title: Text(filteredSocieties[index]),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  cityName: widget.cityName,
                                  societyName: filteredSocieties[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSocietyScreen(cityName: widget.cityName),
            ),
          );
        },
        backgroundColor: Colors.green[700],
        child: Icon(Icons.add),
      ),
    );
  }
}

