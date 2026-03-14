import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/emergency_contact_model.dart';
import '../supabase/services/supabase_service.dart';
import '../services/local_db_service.dart';
import '../ads/banner_ad_widget.dart';

class EmergencyContactsScreen extends StatefulWidget {
  final String societyId;
  final String societyName;

  const EmergencyContactsScreen({
    super.key,
    required this.societyId,
    required this.societyName,
  });

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<EmergencyContact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    
    // 1. Try Local First for speed
    final local = await LocalDatabaseService.instance.getEmergencyContacts(widget.societyId);
    if (local.isNotEmpty) {
      setState(() {
        _contacts = local;
        _isLoading = false;
      });
    }

    // 2. Fetch Fresh from Supabase
    try {
      final fresh = await _fetchFromSupabase();
      if (mounted) {
        setState(() {
          _contacts = fresh;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Temporary mock fetch until Supabase table is created
  Future<List<EmergencyContact>> _fetchFromSupabase() async {
    await Future.delayed(const Duration(seconds: 1));
    final mock = [
      EmergencyContact(id: '1', societyId: widget.societyId, name: 'Main Gate Security', phoneNumber: '03001234567', category: 'Security'),
      EmergencyContact(id: '2', societyId: widget.societyId, name: 'Society Office', phoneNumber: '02139876543', category: 'Admin'),
      EmergencyContact(id: '3', societyId: widget.societyId, name: 'Electrician (Ali)', phoneNumber: '03111112223', category: 'Maintenance'),
      EmergencyContact(id: '4', societyId: widget.societyId, name: 'Ambulance', phoneNumber: '1122', category: 'Emergency'),
    ];
    
    await LocalDatabaseService.instance.saveEmergencyContacts(mock);
    return mock;
  }

  Future<void> _makeCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.societyName} Contacts'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && _contacts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      final contact = _contacts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: contact.category == 'Emergency' ? Colors.red : Colors.green,
                            child: Icon(
                              contact.category == 'Security' ? Icons.security : Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(contact.name),
                          subtitle: Text('${contact.category} • ${contact.phoneNumber}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.call, color: Colors.green),
                            onPressed: () => _makeCall(contact.phoneNumber),
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
