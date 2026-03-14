class Restaurant {
  final String id;
  final String societyId;
  final String name;
  final String cuisine; // e.g., 'Fast Food', 'Desi', 'Chinese'
  final String phoneNumber;
  final String address;
  final double rating;

  Restaurant({
    required this.id,
    required this.societyId,
    required this.name,
    required this.cuisine,
    required this.phoneNumber,
    required this.address,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'society_id': societyId,
      'name': name,
      'cuisine': cuisine,
      'phone_number': phoneNumber,
      'address': address,
      'rating': rating,
    };
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      societyId: json['society_id'],
      name: json['name'],
      cuisine: json['cuisine'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
