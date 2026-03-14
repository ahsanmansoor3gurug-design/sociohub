class Society {
  final String id;
  final String cityId;
  final String name;
  final String? area;
  final String createdBy;
  final String status;
  final DateTime createdAt;

  Society({
    required this.id,
    required this.cityId,
    required this.name,
    this.area,
    required this.createdBy,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_id': cityId,
      'name': name,
      'area': area,
      'created_by': createdBy,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Society.fromJson(Map<String, dynamic> json) {
    return Society(
      id: json['id'],
      cityId: json['city_id'],
      name: json['name'],
      area: json['area'],
      createdBy: json['created_by'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
