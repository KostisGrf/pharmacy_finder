import 'package:pharmacy_finder/models/geometry.dart';

class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map<dynamic, dynamic> json) {
    return Location(json['lat'], json['lng']);
  }
}
