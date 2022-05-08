import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmacy_finder/models/geometry.dart';
import 'package:pharmacy_finder/models/location.dart';
import '../models/place_search.dart';
import '../services/geolocator_service.dart';
import '../services/places_service.dart';
import '../models/place.dart';

class ApplicationBloc extends ChangeNotifier {
  final placesService = PlacesService();
  final geoLocatorService = GeolocatorService();

  Position? currentLocation;
  List<PlaceSearch> searchResults = [];
  Place? cityLocation;
  List<Place> pharmacies = [];
  bool searchWithCurrent = false;

  ApplicationBloc();

  searchPlaces(String? searchQuery) async {
    searchResults = await placesService.getAutoComplete(searchQuery);
    if (searchQuery == null) {
      searchResults = [];
    }
    notifyListeners();
  }

  setCityLocation(String placeId) async {
    cityLocation = await placesService.getCityLocation(placeId);
    searchResults = [];
    notifyListeners();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getLocation();
    cityLocation = Place(
        name: '',
        openNow: false,
        rating: null,
        userRatingCount: null,
        vicinity: '',
        distance: null,
        image: '',
        geometry: Geometry(
            location: Location(
                currentLocation!.latitude, currentLocation!.longitude)));
  }

  setPharmacies({required double lat, required double lng}) async {
    pharmacies = await placesService.getPharmacies(lat: lat, lng: lng);
    pharmacies.sort((a, b) => a.distance!.compareTo(b.distance as num));
    notifyListeners();
  }

  setLocationPref(bool pref) {
    searchWithCurrent = pref;
    notifyListeners();
  }
}
