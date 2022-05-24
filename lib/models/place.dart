import 'dart:ffi';

import 'package:pharmacy_finder/blocs/application_bloc.dart';
import 'package:pharmacy_finder/models/geometry.dart';
import 'package:pharmacy_finder/services/geolocator_service.dart';

class Place {
  final String vicinity;
  final String name;
  final double? rating;
  final int? userRatingCount;
  final Geometry geometry;
  bool openNow;
  final String? phoneNumber;
  final String? image;
  final double? distance;
  late bool onDuty;
  late bool onDutyNow;

  final GeolocatorService geolocatorService = GeolocatorService();
  final ApplicationBloc applicationBloc = ApplicationBloc();

  Place(
      {required this.openNow,
      required this.distance,
      required this.vicinity,
      required this.name,
      required this.rating,
      required this.userRatingCount,
      required this.phoneNumber,
      required this.image,
      required this.geometry});

  Place.fromJson(Map<dynamic, dynamic> json)
      : vicinity = json['vicinity'],
        name = json['name'],
        rating = (json['rating'] != null) ? json['rating'].toDouble() : null,
        userRatingCount = (json['user_ratings_total'] != null)
            ? json['user_ratings_total']
            : null,
        openNow = ((json['opening_hours'] != null))
            ? json['opening_hours']['open_now']
            : false,
        distance = json['distance'],
        image = (json['photos'] != null)
            ? json['photos'][0]['photo_reference']
            : null,
        phoneNumber = (json['phoneNumber'] != null)
            ? json['phoneNumber'].toString().replaceAll(' ', '')
            : null,
        geometry = Geometry.fromJson(json['geometry']);
}
