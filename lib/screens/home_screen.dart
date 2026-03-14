import 'package:flutter/material.dart';
import '../ads/banner_ad_widget.dart';
import 'emergency_contacts_screen.dart';
import 'restaurant_directory_screen.dart';

class HomeScreen extends StatelessWidget {
  final String societyId = "s1"; // MPCHS B-17 Demo ID
  final String cityName;
  final String societyName;

  HomeScreen({required this.cityName, required this.societyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(societyName),
            Text(
              cityName,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                menuCard(context, "🕌 Masjid\nTimings", Colors.blue, null),
                menuCard(context, "🍽️ Restaurants", Colors.orange, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantDirectoryScreen(
                        societyId: societyId,
                        societyName: societyName,
                      ),
                    ),
                  );
                }),
                menuCard(context, "🔧 Community\nServices", Colors.purple, null),
                menuCard(context, "📞 Emergency\nContacts", Colors.red, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyContactsScreen(
                        societyId: societyId,
                        societyName: societyName,
                      ),
                    ),
                  );
                }),
                menuCard(context, "📍 Society\nMap", Colors.teal, null),
                menuCard(context, "📢 Announcements", Colors.indigo, null),
              ],
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget menuCard(BuildContext context, String title, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$title - Coming Soon!"),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color.withOpacity(0.3)],
            ),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
