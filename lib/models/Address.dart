class Address {
  String? road;
  String? quarter;
  String? suburb;
  String? city;
  double lat;
  double lng;

  Address({
    required this.lat,
    required this.lng,
    this.road,
    this.quarter,
    this.suburb,
    this.city,
  });

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      lat: (data['lat'] as num).toDouble(), // Đảm bảo chuyển đổi sang double
      lng: (data['lng'] as num).toDouble(), // Đảm bảo chuyển đổi sang double
      road: data['road'] ?? '',
      quarter: data['quarter'] ?? '',
      suburb: data['suburb'] ?? '',
      city: data['city'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'road': road,
      'quarter': quarter,
      'suburb': suburb,
      'city': city,
    };
  }
}
