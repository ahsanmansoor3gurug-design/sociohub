class EmergencyContact {
  final String id;
  final String societyId;
  final String name;
  final String phoneNumber;
  final String category; // e.g., 'Gate', 'Electrician', 'Ambulance'

  EmergencyContact({
    required this.id,
    required this.societyId,
    required this.name,
    required this.phoneNumber,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'society_id': societyId,
      'name': name,
      'phone_number': phoneNumber,
      'category': category,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      societyId: json['society_id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      category: json['category'],
    );
  }
}
