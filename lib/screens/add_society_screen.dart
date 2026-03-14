import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/supabase_service.dart';
import '../auth/auth_service.dart';
import '../models/society_model.dart';
import '../utils/constants.dart';

class AddSocietyScreen extends StatefulWidget {
  final String cityId;
  final String cityName;

  AddSocietyScreen({required this.cityId, required this.cityName});

  @override
  _AddSocietyScreenState createState() => _AddSocietyScreenState();
}

class _AddSocietyScreenState extends State<AddSocietyScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final AuthService _authService = AuthService();
  final TextEditingController societyNameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Society> existingSocieties = [];
  List<Society> suggestions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchExistingSocieties();
  }

  Future<void> _fetchExistingSocieties() async {
    final societies = await _supabaseService.getSocieties(widget.cityId);
    setState(() {
      existingSocieties = societies;
    });
  }

  void checkDuplicates(String query) {
    setState(() {
      if (query.isEmpty) {
        suggestions = [];
      } else {
        suggestions = existingSocieties
            .where((society) =>
                society.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> addSociety() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      
      String societyName = societyNameController.text.trim();
      
      // Check exact match
      bool exactMatch = existingSocieties.any(
        (society) => society.name.toLowerCase() == societyName.toLowerCase(),
      );

      if (exactMatch) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("This society already exists. Please select it from the list."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newSociety = Society(
        id: const Uuid().v4(),
        cityId: widget.cityId,
        name: societyName,
        area: areaController.text.trim(),
        createdBy: _authService.currentUser?.id ?? 'anonymous',
        status: AppConstants.STATUS_PENDING,
        createdAt: DateTime.now(),
      );

      final success = await _supabaseService.addSociety(newSociety);

      setState(() => isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Society request submitted for approval!"),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        societyNameController.clear();
        areaController.clear();
        suggestions.clear();

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to submit request. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Society"),
        elevation: 0,
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Add Your Society",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Help us build the database. Your society will be reviewed and approved by admin.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),

              // City (Read-only)
              Text(
                "City",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: Text(
                  widget.cityName,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Society Name
              Text(
                "Society Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: societyNameController,
                onChanged: checkDuplicates,
                decoration: InputDecoration(
                  hintText: "Enter society name...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter society name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Suggestions
              if (suggestions.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Similar societies found:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ...suggestions
                          .map(
                            (suggestion) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.blue, size: 20),
                                  SizedBox(width: 8),
                                  Text(suggestion.name),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              SizedBox(height: 20),

              // Area/Location
              Text(
                "Area / Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: areaController,
                decoration: InputDecoration(
                  hintText: "Enter area or location...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter area/location";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Info Box
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You will become the first admin of this society after approval.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addSociety,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Submit for Approval",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
