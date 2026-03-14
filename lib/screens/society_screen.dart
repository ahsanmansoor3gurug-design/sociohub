import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/society_model.dart';
import 'home_screen.dart';
import 'add_society_screen.dart';

class SocietyScreen extends StatefulWidget {
  final String cityId;
  final String cityName;

  SocietyScreen({required this.cityId, required this.cityName});

  @override
  _SocietyScreenState createState() => _SocietyScreenState();
}

class _SocietyScreenState extends State<SocietyScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Society> societies = [];
  List<Society> filteredSocieties = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSocieties();
  }

  Future<void> _fetchSocieties() async {
    setState(() => isLoading = true);
    final fetchedSocieties = await _supabaseService.getSocieties(widget.cityId);
    setState(() {
      societies = fetchedSocieties;
      filteredSocieties = fetchedSocieties;
      isLoading = false;
    });
  }

  void filterSocieties(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSocieties = societies;
      } else {
        filteredSocieties = societies
            .where((society) => society.name.toLowerCase().contains(query.toLowerCase()))
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredSocieties.isEmpty
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
                          final society = filteredSocieties[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: Icon(Icons.home, color: Colors.green),
                              title: Text(society.name),
                              subtitle: society.area != null ? Text(society.area!) : null,
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                      cityName: widget.cityName,
                                      societyName: society.name,
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
              builder: (context) => AddSocietyScreen(
                cityId: widget.cityId,
                cityName: widget.cityName,
              ),
            ),
          ).then((_) => _fetchSocieties()); // Refresh after adding
        },
        backgroundColor: Colors.green[700],
        child: Icon(Icons.add),
      ),
    );
  }
}
