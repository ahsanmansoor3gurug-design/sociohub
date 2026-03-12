class Society {
  final String societyId;
  final String cityId;
  final String societyName;
  final String? area;
  final String createdBy;
  final String status; // pending, approved, rejected
  final DateTime createdAt;

  Society({
    required this.societyId,
    required this.cityId,
    required this.societyName,
    this.area,
    required this.createdBy,
    required this.status,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'societyId': societyId,
      'cityId': cityId,
      'societyName': societyName,
      'area': area,
      'createdBy': createdBy,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Society.fromJson(Map<String, dynamic> json) {
    return Society(
      societyId: json['societyId'],
      cityId: json['cityId'],
      societyName: json['societyName'],
      area: json['area'],
      createdBy: json['createdBy'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

