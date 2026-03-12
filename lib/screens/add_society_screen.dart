import 'package:flutter/material.dart';

class AddSocietyScreen extends StatefulWidget {
  final String cityName;

  AddSocietyScreen({required this.cityName});

  @override
  _AddSocietyScreenState createState() => _AddSocietyScreenState();
}

class _AddSocietyScreenState extends State<AddSocietyScreen> {
  final TextEditingController societyNameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Sample existing societies for duplicate checking
  final List<String> existingSocieties = [
    "DHA Phase 6",
    "Bahria Town Karachi",
    "Gulshan-e-Iqbal",
    "North Nazimabad",
  ];

  List<String> suggestions = [];

  void checkDuplicates(String query) {
    setState(() {
      suggestions = existingSocieties
          .where((society) => society.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void addSociety() {
    if (formKey.currentState!.validate()) {
      String societyName = societyNameController.text.trim();
      
      // Check exact match
      bool exactMatch = existingSocieties.any(
        (society) => society.toLowerCase() == societyName.toLowerCase(),
      );

      if (exactMatch) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("This society already exists. Please select it from the list."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // If no exact match, show success message
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
                                  Text(suggestion),
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
                  onPressed: addSociety,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
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

